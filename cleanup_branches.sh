#!/bin/bash

# Branch Cleanup Script for Sm-a266b-open-source-kernel-
# This script will delete merged and abandoned branches
# Run this script from the repository root

set -e

echo "==========================================="
echo "Branch Cleanup Script"
echo "==========================================="
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Branches that are merged to main and safe to delete
MERGED_BRANCHES=(
    "copilot/fix-checks-references-issue"
    "copilot/keep-repo-synced-and-clean"
    "copilot/sub-pr-27"
    "copilot/sub-pr-27-again"
    "copilot/sub-pr-27-another-one"
    "copilot/update-action-workflows"
    "copilot/update-kernel-configuration"
)

# Branches with no real work (only planning commits)
ABANDONED_BRANCHES=(
    "copilot/fix-kconfig-issues-again"
    "copilot/fix-kconfig-issues-yet-again"
)

# Development artifact branches
DEV_ARTIFACT_BRANCHES=(
    "patch-wildksu-susfs"
)

# Combine all branches to delete
ALL_BRANCHES_TO_DELETE=(
    "${MERGED_BRANCHES[@]}"
    "${ABANDONED_BRANCHES[@]}"
    "${DEV_ARTIFACT_BRANCHES[@]}"
)

echo "This script will delete the following branches:"
echo ""
echo -e "${YELLOW}Merged to main (safe to delete):${NC}"
for branch in "${MERGED_BRANCHES[@]}"; do
    echo "  - $branch"
done

echo ""
echo -e "${YELLOW}Abandoned (only planning commits):${NC}"
for branch in "${ABANDONED_BRANCHES[@]}"; do
    echo "  - $branch"
done

echo ""
echo -e "${YELLOW}Development artifacts (VS Code config, etc.):${NC}"
for branch in "${DEV_ARTIFACT_BRANCHES[@]}"; do
    echo "  - $branch"
done

echo ""
echo -e "${RED}WARNING: This action cannot be undone!${NC}"
echo "Branches will be deleted from the remote repository."
echo ""
read -p "Do you want to proceed? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Cleanup cancelled."
    exit 0
fi

echo ""
echo "Starting branch cleanup..."
echo ""

# Counter for successful deletions
deleted_count=0
failed_count=0

# Delete each branch
for branch in "${ALL_BRANCHES_TO_DELETE[@]}"; do
    echo -n "Deleting $branch... "
    
    # Try to delete the remote branch
    if git push origin --delete "$branch" 2>/dev/null; then
        echo -e "${GREEN}✓ Deleted${NC}"
        ((deleted_count++))
    else
        echo -e "${RED}✗ Failed (may not exist or already deleted)${NC}"
        ((failed_count++))
    fi
    
    # Also delete local tracking branch if it exists
    if git branch -r | grep -q "origin/$branch"; then
        git branch -rd "origin/$branch" 2>/dev/null || true
    fi
done

echo ""
echo "==========================================="
echo "Cleanup Summary"
echo "==========================================="
echo -e "${GREEN}Successfully deleted: $deleted_count branches${NC}"
if [ $failed_count -gt 0 ]; then
    echo -e "${YELLOW}Failed/Already deleted: $failed_count branches${NC}"
fi
echo ""
echo "Your repository has been cleaned up!"
echo "See BRANCH_CLEANUP_GUIDE.md for best practices."
echo ""
echo "Remaining branches:"
git branch -r | grep -v HEAD
echo ""
