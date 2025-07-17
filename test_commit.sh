#!/bin/bash

# Test script to simulate the GitHub Actions daily commit workflow
# This can be used to test the commit logic locally

echo "🔍 Testing daily commit workflow..."

# Set up git config (adjust these to your details)
git config --global user.name "mdayan8"
git config --global user.email "mdayanbag@gmail.com"

# Add current date and time to daily.md
echo "🕒 $(date)" >> daily.md

# Check if there are changes to commit
if git diff --quiet daily.md; then
  echo "❌ No changes to commit"
  exit 0
fi

echo "✅ Changes detected in daily.md"

# Stage and commit changes
git add daily.md
git commit -m "📅 Daily update: $(date +'%Y-%m-%d %H:%M UTC')"

echo "✅ Test commit successful!"
echo "📄 Current daily.md content:"
cat daily.md