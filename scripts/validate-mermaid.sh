#!/bin/bash
# Validate all Mermaid diagrams using mermaid-cli (mmdc)
# Used in CI/CD and local development
# T009: Create scripts/validate-mermaid.sh

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "Validating Mermaid diagrams..."

# Check if mmdc is installed
if ! command -v mmdc &> /dev/null; then
    echo -e "${RED}Error: mermaid-cli (mmdc) not found${NC}"
    echo "Install: npm install -g @mermaid-js/mermaid-cli"
    exit 1
fi

# Find all .mmd files
DIAGRAM_DIR="docs/diagrams"
if [ ! -d "$DIAGRAM_DIR" ]; then
    echo -e "${YELLOW}Warning: $DIAGRAM_DIR directory not found${NC}"
    echo "No diagrams to validate."
    exit 0
fi

# Count diagrams
DIAGRAM_COUNT=$(find "$DIAGRAM_DIR" -name "*.mmd" 2>/dev/null | wc -l)

if [ "$DIAGRAM_COUNT" -eq 0 ]; then
    echo -e "${YELLOW}No .mmd files found in $DIAGRAM_DIR${NC}"
    echo "Diagrams will be created in later phases."
    exit 0
fi

echo "Found $DIAGRAM_COUNT diagram(s) to validate..."
echo ""

# Validate each diagram
ERRORS=0
SUCCESS=0

find "$DIAGRAM_DIR" -name "*.mmd" | while read -r file; do
    FILENAME=$(basename "$file")
    echo -n "Checking $FILENAME... "

    # Validate by attempting to convert to SVG
    if mmdc -i "$file" -o /tmp/mermaid-test-$$.svg 2>/dev/null; then
        echo -e "${GREEN}✓${NC}"
        SUCCESS=$((SUCCESS + 1))
        # Clean up test file
        rm -f /tmp/mermaid-test-$$.svg
    else
        echo -e "${RED}✗ FAILED${NC}"
        echo -e "${RED}  Syntax error in $file${NC}"
        ERRORS=$((ERRORS + 1))

        # Show error details
        echo "  Running mmdc with error output:"
        mmdc -i "$file" -o /tmp/mermaid-test-$$.svg 2>&1 | sed 's/^/    /' || true
        echo ""
    fi
done

# Check if loop ran successfully
if [ "${PIPESTATUS[0]}" -ne 0 ]; then
    echo -e "${RED}Error finding diagram files${NC}"
    exit 1
fi

# Summary
echo ""
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✓ All $DIAGRAM_COUNT diagram(s) validated successfully!${NC}"
    exit 0
else
    echo -e "${RED}✗ $ERRORS diagram(s) failed validation${NC}"
    echo "Fix syntax errors before committing."
    exit 1
fi
