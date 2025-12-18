#!/bin/bash
# Check that every docs/*.md has a corresponding *-terry.md file
# Enforces dual documentation requirement
# T010: Create scripts/check-doc-pairs.sh

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "Checking documentation pairs (standard + Terry versions)..."

DOCS_DIR="docs"
if [ ! -d "$DOCS_DIR" ]; then
    echo -e "${RED}Error: $DOCS_DIR directory not found${NC}"
    exit 1
fi

# Find all standard .md files (excluding *-terry.md files)
STANDARD_DOCS=$(find "$DOCS_DIR" -maxdepth 1 -name "*.md" ! -name "*-terry.md" -type f)

if [ -z "$STANDARD_DOCS" ]; then
    echo -e "${YELLOW}No documentation files found in $DOCS_DIR${NC}"
    echo "Documentation will be created in later phases."
    exit 0
fi

echo ""
MISSING=0
FOUND=0

for standard_file in $STANDARD_DOCS; do
    # Get base name without extension
    BASE=$(basename "$standard_file" .md)
    TERRY_FILE="$DOCS_DIR/${BASE}-terry.md"

    echo -n "Checking $BASE.md... "

    if [ -f "$TERRY_FILE" ]; then
        echo -e "${GREEN}✓${NC} (has Terry version)"
        FOUND=$((FOUND + 1))
    else
        echo -e "${RED}✗ MISSING${NC}"
        echo -e "${RED}  Expected: $TERRY_FILE${NC}"
        MISSING=$((MISSING + 1))
    fi
done

echo ""
if [ $MISSING -eq 0 ]; then
    echo -e "${GREEN}✓ All documentation has Terry versions!${NC}"
    echo "  Total pairs: $FOUND"
    exit 0
else
    echo -e "${RED}✗ $MISSING documentation file(s) missing Terry versions${NC}"
    echo ""
    echo "Dual documentation requirement:"
    echo "  - Every docs/{topic}.md must have docs/{topic}-terry.md"
    echo "  - See docs/STYLE_GUIDE.md for Terry documentation guidelines"
    exit 1
fi
