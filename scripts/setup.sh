#!/bin/bash
# Ambient Code Reference Repository - Setup Script
# Target: Complete in under 10 minutes
# Consolidated: T008 (was T008 + T024 + T025 + T026)

set -e  # Exit on any error

# Color output for better UX
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Track timing for <10 minute goal
START_TIME=$(date +%s)

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Ambient Code Reference Repository Setup${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Step 1: Environment Validation
echo -e "${YELLOW}[1/6]${NC} Validating environment..."

# Check Git
if ! command -v git &> /dev/null; then
    echo -e "${RED}✗ Error: git not found${NC}"
    echo "Install: https://git-scm.com/downloads"
    exit 1
fi
echo -e "${GREEN}✓${NC} Git $(git --version | cut -d' ' -f3) detected"

# Check Node.js (optional but recommended)
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version | cut -d'v' -f2)
    echo -e "${GREEN}✓${NC} Node.js $NODE_VERSION detected"
    HAS_NODE=true
else
    echo -e "${YELLOW}⚠${NC} Node.js not found (optional for mermaid-cli, markdownlint)"
    echo "  Install from: https://nodejs.org/"
    HAS_NODE=false
fi

# Check npm (if Node exists)
if [ "$HAS_NODE" = true ]; then
    if command -v npm &> /dev/null; then
        NPM_VERSION=$(npm --version)
        echo -e "${GREEN}✓${NC} npm $NPM_VERSION detected"
    else
        echo -e "${YELLOW}⚠${NC} npm not found (should come with Node.js)"
    fi
fi

# Step 2: Directory Structure Verification
echo ""
echo -e "${YELLOW}[2/6]${NC} Verifying directory structure..."

REQUIRED_DIRS=(
    ".github/workflows"
    ".github/ISSUE_TEMPLATE"
    ".claude/agents"
    ".claude/context"
    ".claude/commands"
    "docs/diagrams"
    "docs/tutorials"
    "docs/comparison"
    "docs/adr"
    "docs/adoption"
    "scripts"
    ".gitlab"
)

MISSING_DIRS=()
for dir in "${REQUIRED_DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
        MISSING_DIRS+=("$dir")
    fi
done

if [ ${#MISSING_DIRS[@]} -eq 0 ]; then
    echo -e "${GREEN}✓${NC} All required directories exist (${#REQUIRED_DIRS[@]} directories)"
else
    echo -e "${RED}✗ Missing directories:${NC}"
    for dir in "${MISSING_DIRS[@]}"; do
        echo "  - $dir"
    done
    echo ""
    echo "Creating missing directories..."
    for dir in "${MISSING_DIRS[@]}"; do
        mkdir -p "$dir"
        echo -e "${GREEN}✓${NC} Created $dir"
    done
fi

# Step 3: Install Optional Tools
echo ""
echo -e "${YELLOW}[3/6]${NC} Checking optional development tools..."

if [ "$HAS_NODE" = true ]; then
    # Check for mermaid-cli
    if command -v mmdc &> /dev/null; then
        echo -e "${GREEN}✓${NC} mermaid-cli already installed"
    else
        echo -e "${YELLOW}⚠${NC} mermaid-cli not found"
        read -p "Install mermaid-cli globally? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Installing mermaid-cli..."
            npm install -g @mermaid-js/mermaid-cli
            echo -e "${GREEN}✓${NC} mermaid-cli installed"
        else
            echo -e "${YELLOW}⚠${NC} Skipped mermaid-cli installation"
            echo "  Install later: npm install -g @mermaid-js/mermaid-cli"
        fi
    fi

    # Check for markdownlint-cli
    if command -v markdownlint &> /dev/null; then
        echo -e "${GREEN}✓${NC} markdownlint-cli already installed"
    else
        echo -e "${YELLOW}⚠${NC} markdownlint-cli not found"
        read -p "Install markdownlint-cli globally? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Installing markdownlint-cli..."
            npm install -g markdownlint-cli
            echo -e "${GREEN}✓${NC} markdownlint-cli installed"
        else
            echo -e "${YELLOW}⚠${NC} Skipped markdownlint-cli installation"
            echo "  Install later: npm install -g markdownlint-cli"
        fi
    fi
fi

# Check for shellcheck
if command -v shellcheck &> /dev/null; then
    echo -e "${GREEN}✓${NC} shellcheck already installed"
else
    echo -e "${YELLOW}⚠${NC} shellcheck not found (used for script validation)"
    echo "  Install from: https://www.shellcheck.net/"
fi

# Check for asciinema (for tutorial recording)
if command -v asciinema &> /dev/null; then
    echo -e "${GREEN}✓${NC} asciinema already installed"
else
    echo -e "${YELLOW}⚠${NC} asciinema not found (needed for recording tutorials)"
    echo "  Install from: https://asciinema.org/"
fi

# Step 4: Run Validation Scripts
echo ""
echo -e "${YELLOW}[4/6]${NC} Running validation checks..."

# Make scripts executable
if [ -d "scripts" ]; then
    chmod +x scripts/*.sh 2>/dev/null || true
    echo -e "${GREEN}✓${NC} Scripts marked executable"
fi

# Check doc pairs (if script exists)
if [ -f "scripts/check-doc-pairs.sh" ]; then
    echo "Checking documentation pairs..."
    if ./scripts/check-doc-pairs.sh; then
        echo -e "${GREEN}✓${NC} Documentation pairs validated"
    else
        echo -e "${YELLOW}⚠${NC} Some documentation pairs missing (expected during initial setup)"
    fi
else
    echo -e "${YELLOW}⚠${NC} check-doc-pairs.sh not yet created (will be available in Phase 2)"
fi

# Validate Mermaid diagrams (if script exists and mmdc available)
if [ -f "scripts/validate-mermaid.sh" ]; then
    if command -v mmdc &> /dev/null; then
        echo "Validating Mermaid diagrams..."
        if ./scripts/validate-mermaid.sh; then
            echo -e "${GREEN}✓${NC} Mermaid diagrams validated"
        else
            echo -e "${YELLOW}⚠${NC} Some diagrams have syntax errors (or no diagrams yet)"
        fi
    else
        echo -e "${YELLOW}⚠${NC} Skipping Mermaid validation (mmdc not installed)"
    fi
else
    echo -e "${YELLOW}⚠${NC} validate-mermaid.sh not yet created (will be available in Phase 2)"
fi

# Step 5: Git Configuration Check
echo ""
echo -e "${YELLOW}[5/6]${NC} Checking Git configuration..."

if git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Git repository initialized"

    # Check for remote
    if git remote -v | grep -q origin; then
        REMOTE_URL=$(git remote get-url origin)
        echo -e "${GREEN}✓${NC} Remote configured: $REMOTE_URL"
    else
        echo -e "${YELLOW}⚠${NC} No Git remote configured"
        echo "  Add remote: git remote add origin <your-repo-url>"
    fi

    # Check current branch
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    echo -e "${GREEN}✓${NC} Current branch: $CURRENT_BRANCH"
else
    echo -e "${RED}✗ Not a Git repository${NC}"
    echo "  Initialize: git init"
    exit 1
fi

# Step 6: Final Status Report
echo ""
echo -e "${YELLOW}[6/6]${NC} Setup complete! Generating status report..."
echo ""

# Calculate elapsed time
END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))
MINUTES=$((ELAPSED / 60))
SECONDS=$((ELAPSED % 60))

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Setup Status Report${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Required components
echo -e "${GREEN}✓ Required Components:${NC}"
echo "  • Git repository initialized"
echo "  • Directory structure complete"
echo "  • Scripts marked executable"
echo ""

# Optional components
echo -e "${YELLOW}Optional Components:${NC}"
if [ "$HAS_NODE" = true ]; then
    echo "  ✓ Node.js installed"
else
    echo "  ⚠ Node.js not installed (recommended)"
fi

if command -v mmdc &> /dev/null; then
    echo "  ✓ mermaid-cli installed"
else
    echo "  ⚠ mermaid-cli not installed (recommended)"
fi

if command -v markdownlint &> /dev/null; then
    echo "  ✓ markdownlint-cli installed"
else
    echo "  ⚠ markdownlint-cli not installed (recommended)"
fi

if command -v shellcheck &> /dev/null; then
    echo "  ✓ shellcheck installed"
else
    echo "  ⚠ shellcheck not installed (recommended)"
fi

if command -v asciinema &> /dev/null; then
    echo "  ✓ asciinema installed"
else
    echo "  ⚠ asciinema not installed (needed for tutorial recording)"
fi

echo ""

# Time check (<10 minute goal)
echo -e "${GREEN}⏱ Setup Time:${NC} ${MINUTES}m ${SECONDS}s"
if [ $ELAPSED -lt 600 ]; then
    echo -e "${GREEN}✓ Setup completed in under 10 minutes!${NC}"
else
    echo -e "${YELLOW}⚠ Setup took longer than 10 minutes (target: <10min)${NC}"
fi

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Next Steps${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "1. Review documentation:"
echo "   - README.md for overview"
echo "   - docs/STYLE_GUIDE.md for writing standards"
echo "   - .github/PROJECT_BOARD.md for workflow"
echo ""
echo "2. Install optional tools (if not done):"
echo "   npm install -g @mermaid-js/mermaid-cli markdownlint-cli"
echo ""
echo "3. Start developing:"
echo "   - Follow docs/quickstart.md (when available)"
echo "   - See CONTRIBUTING.md for guidelines"
echo ""
echo "4. Run validations:"
echo "   ./scripts/validate-mermaid.sh    # Validate diagrams"
echo "   ./scripts/check-doc-pairs.sh     # Check Terry versions"
echo "   ./scripts/lint-all.sh            # Run all linters (Phase 2+)"
echo ""
echo -e "${GREEN}✓ Setup complete! Happy coding!${NC}"
echo ""
