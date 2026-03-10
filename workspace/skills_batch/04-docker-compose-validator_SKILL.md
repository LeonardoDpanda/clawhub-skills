---
name: docker-compose-validator
description: Validate Docker Compose files for syntax errors, best practices, security issues, and common misconfigurations. Use when reviewing docker-compose.yml files, troubleshooting container deployments, or ensuring production readiness.
---

# Docker Compose Validator

Analyze and validate Docker Compose configurations for correctness, security, and best practices.

## When to Use

- Validating docker-compose.yml syntax before deployment
- Checking for security best practices
- Reviewing production readiness
- Identifying common misconfigurations
- Migrating between Compose versions

## When NOT to Use

- Building images (use docker build)
- Running containers (use docker-compose up)
- Complex orchestration (use Kubernetes)
- Real-time monitoring (use Docker stats)

## Examples

### Basic Syntax Validation

```bash
# Validate Compose file syntax
docker-compose -f docker-compose.yml config

# Validate and output processed config
docker-compose config > docker-compose.processed.yml

# Check multiple files
docker-compose -f docker-compose.yml -f docker-compose.prod.yml config
```

### Comprehensive Validation Script

```bash
#!/bin/bash
COMPOSE_FILE="${1:-docker-compose.yml}"

echo "╔════════════════════════════════════════════════╗"
echo "║    Docker Compose Validation Report            ║"
echo "╚════════════════════════════════════════════════╝"
echo "File: $COMPOSE_FILE"
echo

# Check if file exists
if [ ! -f "$COMPOSE_FILE" ]; then
    echo "❌ File not found: $COMPOSE_FILE"
    exit 1
fi

# 1. Syntax Validation
echo "🔍 Step 1: Syntax Validation"
if docker-compose -f "$COMPOSE_FILE" config > /dev/null 2>&1; then
    echo "   ✅ Valid YAML syntax"
else
    echo "   ❌ Syntax error:"
    docker-compose -f "$COMPOSE_FILE" config 2>&1 | head -20
    exit 1
fi

# 2. Required Fields Check
echo
echo "🔍 Step 2: Required Fields"
if grep -q "version:" "$COMPOSE_FILE"; then
    echo "   ✅ Version specified"
else
    echo "   ⚠️  No version specified (defaults to latest)"
fi

if grep -q "services:" "$COMPOSE_FILE"; then
    echo "   ✅ Services section present"
else
    echo "   ❌ Missing services section"
fi

# 3. Security Checks
echo
echo "🔒 Step 3: Security Analysis"

# Check for privileged mode
if grep -q "privileged: true" "$COMPOSE_FILE"; then
    echo "   ⚠️  Found privileged containers (security risk)"
    grep -B5 "privileged: true" "$COMPOSE_FILE" | grep -E "^[a-zA-Z]"
fi

# Check for root user
if grep -q "user: root" "$COMPOSE_FILE" || ! grep -q "user:" "$COMPOSE_FILE"; then
    echo "   ⚠️  Containers running as root (consider specifying user)"
fi

# Check for exposed Docker socket
if grep -q "/var/run/docker.sock" "$COMPOSE_FILE"; then
    echo "   ⚠️  Docker socket mounted (major security risk)"
fi

# Check for secrets in environment
if grep -iE "(password|secret|key|token)" "$COMPOSE_FILE" | grep -v "^#" | grep -q "."; then
    echo "   ⚠️  Potential secrets in environment variables:"
    grep -iE "(password|secret|key|token)" "$COMPOSE_FILE" | head -5
fi

# 4. Best Practices
echo
echo "✨ Step 4: Best Practices"

# Resource limits
if grep -q "deploy:" "$COMPOSE_FILE" && grep -q "resources:" "$COMPOSE_FILE"; then
    echo "   ✅ Resource limits defined"
else
    echo "   ⚠️  No resource limits (risk of resource exhaustion)"
fi

# Health checks
if grep -q "healthcheck:" "$COMPOSE_FILE"; then
    echo "   ✅ Health checks configured"
else
    echo "   ⚠️  No health checks (recommend adding)"
fi

# Restart policy
if grep -q "restart:" "$COMPOSE_FILE"; then
    echo "   ✅ Restart policy defined"
else
    echo "   ⚠️  No restart policy"
fi

# 5. Network Configuration
echo
echo "🌐 Step 5: Network Configuration"
if grep -q "networks:" "$COMPOSE_FILE"; then
    echo "   ✅ Custom networks defined"
else
    echo "   ℹ️  Using default bridge network"
fi

# 6. Volume Analysis
echo
echo "💾 Step 6: Volume Configuration"
volumes=$(grep -A1 "volumes:" "$COMPOSE_FILE" | grep "^-" | wc -l)
if [ "$volumes" -gt 0 ]; then
    echo "   ℹ️  Found $volumes volume mounts"
fi

echo
echo "✅ Validation Complete"
```

### Version Compatibility Check

```bash
#!/bin/bash
COMPOSE_FILE="${1:-docker-compose.yml}"

echo "Checking Docker Compose version compatibility..."

# Detect version from file
version=$(grep "^version:" "$COMPOSE_FILE" | sed 's/.*["'\''"]\(.*\)["'\''"].*/\1/')
echo "File version: $version"

# Check local Compose version
local_version=$(docker-compose --version | grep -oE "[0-9]+\.[0-9]+\.[0-9]+")
echo "Local version: $local_version"

# Version compatibility matrix
case "$version" in
    "3.8"|"3.7"|"3.6"|"3.5"|"3.4"|"3.3"|"3.2"|"3.1"|"3.0")
        echo "✅ Version 3.x requires Docker Engine 1.13.0+"
        ;;
    "2.4"|"2.3"|"2.2"|"2.1"|"2.0")
        echo "✅ Version 2.x requires Docker Engine 1.10.0+"
        ;;
    "2")
        echo "⚠️  Legacy version 2, consider upgrading to 3.x"
        ;;
    *)
        echo "⚠️  Unknown or unspecified version"
        ;;
esac
```

### Production Readiness Checklist

```bash
#!/bin/bash
COMPOSE_FILE="${1:-docker-compose.yml}"

echo "Production Readiness Checklist"
echo "=============================="

checks_passed=0
checks_total=10

check() {
    if [ $1 -eq 0 ]; then
        echo "✅ $2"
        ((checks_passed++))
    else
        echo "❌ $2"
    fi
}

# Check 1: Valid syntax
docker-compose -f "$COMPOSE_FILE" config > /dev/null 2>&1
check $? "Valid YAML syntax"

# Check 2: Image tags specified (not latest)
! grep -E "image:.*:latest" "$COMPOSE_FILE" > /dev/null
check $? "No 'latest' tags (use specific versions)"

# Check 3: Resource limits
grep -q "resources:" "$COMPOSE_FILE"
check $? "Resource limits configured"

# Check 4: Restart policy
grep -q "restart: unless-stopped\|restart: always" "$COMPOSE_FILE"
check $? "Restart policy defined"

# Check 5: No privileged mode
! grep -q "privileged: true" "$COMPOSE_FILE"
check $? "No privileged containers"

# Check 6: Health checks
grep -q "healthcheck:" "$COMPOSE_FILE"
check $? "Health checks configured"

# Check 7: Log rotation
grep -q "logging:" "$COMPOSE_FILE"
check $? "Log configuration defined"

# Check 8: Environment variables from file/secrets
! grep -E "(password|secret|key)" "$COMPOSE_FILE" | grep -v "^#" | grep -q "."
check $? "No hardcoded secrets"

# Check 9: CPU/Memory limits
grep -qE "(cpus|memory):" "$COMPOSE_FILE"
check $? "CPU/Memory limits set"

# Check 10: Read-only filesystem (optional but good)
grep -q "read_only: true" "$COMPOSE_FILE"
readonly_check=$?
if [ $readonly_check -eq 0 ]; then
    echo "✅ Read-only filesystems (bonus!)"
    ((checks_passed++))
else
    echo "⚠️  Consider read-only filesystems"
fi

echo
echo "Score: $checks_passed/$checks_total checks passed"
if [ $checks_passed -ge 8 ]; then
    echo "🎉 Production ready!"
elif [ $checks_passed -ge 5 ]; then
    echo "⚠️  Review recommended before production"
else
    echo "❌ Not ready for production"
fi
```

## Common Issues & Solutions

| Issue | Detection | Fix |
|-------|-----------|-----|
| Hardcoded secrets | grep password/secret | Use env files or Docker secrets |
| No resource limits | Missing resources: | Add deploy.resources |
| Using 'latest' tag | image:.*:latest | Pin to specific version |
| Privileged containers | privileged: true | Remove unless absolutely necessary |
| Exposed Docker socket | docker.sock mount | Use Docker API or alternative |

## Pricing

**$6 USD** - One-time purchase
- Complete syntax validation
- Security vulnerability scanning
- Best practices analysis
- Production readiness checklist
- Version compatibility checking
