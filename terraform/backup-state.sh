#!/bin/bash

set -e

BACKUP_DIR="$HOME/.terraform-state-backups/ecommerce"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
DEST="$BACKUP_DIR/$TIMESTAMP"

echo "Destination: $DEST"

mkdir -p "$DEST"

# Backup workspace states
if [ -d "terraform.tfstate.d" ]; then
  cp -r terraform.tfstate.d/ "$DEST/"
  echo "Backed up workspace states: $(ls terraform.tfstate.d/)"
fi

# Backup default state if exists
if [ -f "terraform.tfstate" ]; then
  cp terraform.tfstate "$DEST/"
  echo "Backed up default state"
fi

echo ""
echo "Backup complete: $DEST"
echo "Backups available:"
ls -1 "$BACKUP_DIR/" 2>/dev/null | sort -r | head -10
