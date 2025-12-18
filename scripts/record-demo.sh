#!/bin/bash
# Record Asciinema tutorial demonstrations
# T011: Create scripts/record-demo.sh

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check if asciinema is installed
if ! command -v asciinema &> /dev/null; then
    echo -e "${RED}Error: asciinema not found${NC}"
    echo "Install: https://asciinema.org/"
    exit 1
fi

# Usage function
usage() {
    echo "Usage: $0 <tutorial-name>"
    echo ""
    echo "Available tutorials:"
    echo "  setup          - Demonstrate complete setup from git clone to ready state"
    echo "  first-feature  - Demonstrate building a feature following template patterns"
    echo "  agent-workflow - Demonstrate CBA issue-to-PR flow"
    echo ""
    echo "Examples:"
    echo "  $0 setup"
    echo "  $0 first-feature"
    exit 1
}

# Check arguments
if [ $# -ne 1 ]; then
    usage
fi

TUTORIAL="$1"
OUTPUT_DIR="docs/tutorials"
OUTPUT_FILE="$OUTPUT_DIR/${TUTORIAL}.cast"

# Create tutorials directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Tutorial-specific instructions
case "$TUTORIAL" in
    setup)
        echo -e "${BLUE}========================================${NC}"
        echo -e "${BLUE}Recording: Setup Tutorial${NC}"
        echo -e "${BLUE}========================================${NC}"
        echo ""
        echo "This demo will record:"
        echo "  1. git clone <repo-url>"
        echo "  2. cd ambient-reference-repo"
        echo "  3. ./scripts/setup.sh"
        echo "  4. Verification steps"
        echo ""
        echo "Tips:"
        echo "  - Type slowly and clearly"
        echo "  - Pause briefly between commands"
        echo "  - Show successful completion"
        echo ""
        ;;
    first-feature)
        echo -e "${BLUE}========================================${NC}"
        echo -e "${BLUE}Recording: First Feature Tutorial${NC}"
        echo -e "${BLUE}========================================${NC}"
        echo ""
        echo "This demo will record:"
        echo "  1. Create feature branch"
        echo "  2. Make changes following template patterns"
        echo "  3. Run validation scripts"
        echo "  4. Create commit"
        echo ""
        echo "Tips:"
        echo "  - Follow patterns from docs/tutorial.md"
        echo "  - Show validation passing"
        echo "  - Demonstrate dual documentation"
        echo ""
        ;;
    agent-workflow)
        echo -e "${BLUE}========================================${NC}"
        echo -e "${BLUE}Recording: Agent Workflow Tutorial${NC}"
        echo -e "${BLUE}========================================${NC}"
        echo ""
        echo "This demo will record:"
        echo "  1. Create GitHub issue"
        echo "  2. Trigger Codebase Agent"
        echo "  3. Review agent plan"
        echo "  4. Agent creates PR"
        echo ""
        echo "Tips:"
        echo "  - Show issue creation clearly"
        echo "  - Demonstrate approval workflow"
        echo "  - Show final PR"
        echo ""
        ;;
    *)
        echo -e "${RED}Error: Unknown tutorial '$TUTORIAL'${NC}"
        echo ""
        usage
        ;;
esac

echo -e "${YELLOW}Press ENTER when ready to start recording...${NC}"
read -r

echo ""
echo "Starting recording in 3 seconds..."
sleep 1
echo "2..."
sleep 1
echo "1..."
sleep 1
echo ""

# Record the tutorial
echo -e "${GREEN}Recording started!${NC}"
echo -e "${GREEN}Press Ctrl+D or type 'exit' when done${NC}"
echo ""

asciinema rec "$OUTPUT_FILE"

echo ""
echo -e "${GREEN}✓ Recording saved to $OUTPUT_FILE${NC}"
echo ""
echo "Next steps:"
echo "  1. Review: asciinema play $OUTPUT_FILE"
echo "  2. Re-record if needed: $0 $TUTORIAL"
echo "  3. Commit: git add $OUTPUT_FILE && git commit -m \"Add $TUTORIAL tutorial\""
echo ""
