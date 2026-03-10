#!/bin/bash
# Batch publish Skills to Gumroad
# Using existing products as templates

GUMROAD_TOKEN="$GUMROAD_API_TOKEN"

# Products to create with their pricing
# Based on skill-registry.json data

declare -A products
declare -A prices

products[password-generator]="Generate secure, customizable passwords"
prices[password-generator]=400

products[csv-processor]="Process CSV files with filtering, sorting"
prices[csv-processor]=500

products[markdown-formatter]="Format and lint Markdown documents"
prices[markdown-formatter]=300

products[system-health-check]="Monitor system health metrics"
prices[system-health-check]=500

products[url-encoder]="Encode/decode URLs and base64"
prices[url-encoder]=300

products[csv-data-analyzer]="Analyze CSV for statistics and patterns"
prices[csv-data-analyzer]=600

products[text-diff-comparator]="Compare text files and generate patches"
prices[text-diff-comparator]=500

products[json-schema-validator]="Validate JSON against schemas"
prices[json-schema-validator]=700

products[url-shortener-expander]="Shorten and expand URLs"
prices[url-shortener-expander]=300

products[timestamp-converter]="Convert timestamps and date formats"
prices[timestamp-converter]=300

# Create each product
for slug in "${!products[@]}"; do
  echo "Creating: $slug"
  
  curl -s -X POST "https://api.gumroad.com/v2/products" \
    -u "$GUMROAD_TOKEN:" \
    -d "product[name]=OpenClaw Skill: $slug" \
    -d "product[description]=${products[$slug]}" \
    -d "product[price]=${prices[$slug]}" \
    -d "product[currency]=usd" \
    -d "product[custom_receipt]=Thank you for purchasing this OpenClaw Skill!" \
    -d "product[custom_permalink]=$slug" \
    -d "product[show_custom_fields]=false" \
    -d "product[is_physical]=false" \
    -d "product[custom_summary]=OpenClaw Skill - Automated tool" \
    2>/dev/null | tee -a /workspace/projects/workspace/memory/gumroad-publish.log
  
  echo "" >> /workspace/projects/workspace/memory/gumroad-publish.log
  echo "---" >> /workspace/projects/workspace/memory/gumroad-publish.log
  
  sleep 1
done

echo "Batch complete. Log saved to memory/gumroad-publish.log"
