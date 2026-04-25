import os
import logging
from datetime import datetime, timezone, timedelta

import boto3
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)

ec2 = boto3.client("ec2")


def lambda_handler(event, context):
    retention_days = int(os.environ.get("RETENTION_DAYS", "365"))
    cutoff_time = datetime.now(timezone.utc) - timedelta(days=retention_days)

    logger.info(
        "Starting snapshot cleanup for snapshots older than %s days (cutoff: %s)",
        retention_days,
        cutoff_time.isoformat()
    )

    total_snapshots = []
    deleted_snapshots = []
    skipped_snapshots = []
    failed_snapshots = []

    try:
        paginator = ec2.get_paginator("describe_snapshots")

        for page in paginator.paginate(OwnerIds=["self"]):
            for snapshot in page.get("Snapshots", []):
                snapshot_id = snapshot["SnapshotId"]
                start_time = snapshot["StartTime"]

                total_snapshots.append(snapshot_id)

                try:
                    if start_time < cutoff_time:
                        logger.info("Deleting snapshot %s", snapshot_id)
                        ec2.delete_snapshot(SnapshotId=snapshot_id)
                        deleted_snapshots.append(snapshot_id)
                    else:
                        logger.info("Skipping snapshot %s (not old enough)", snapshot_id)
                        skipped_snapshots.append(snapshot_id)

                except ClientError as e:
                    logger.error(
                        "Failed to delete snapshot %s: %s",
                        snapshot_id,
                        str(e)
                    )
                    failed_snapshots.append(snapshot_id)

    except ClientError as e:
        logger.error("Error retrieving snapshots: %s", str(e))
        raise

    logger.info(
        "Summary: Total=%s, Deleted=%s, Skipped=%s, Failed=%s",
        len(total_snapshots),
        len(deleted_snapshots),
        len(skipped_snapshots),
        len(failed_snapshots)
    )

    return {
        "total": len(total_snapshots),
        "deleted": len(deleted_snapshots),
        "skipped": len(skipped_snapshots),
        "failed": len(failed_snapshots),
        "deleted_snapshots": deleted_snapshots,
        "failed_snapshots": failed_snapshots
    }