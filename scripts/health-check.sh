#!/bin/bash
# Health check for dog-training.online
# Returns: ✅ or 🔴 with issues (silent if all OK)
# Usage: ./scripts/health-check.sh

BASE="https://dog-training.online"

check_page() {
  local url="$1"
  local expected="$2"
  local title=$(curl -sL "$url" 2>/dev/null | grep -o '<title>[^<]*</title>' | head -1)
  local size=$(curl -sL "$url" 2>/dev/null | wc -c)
  
  if [ -z "$title" ]; then
    echo "🔴 $url - NO RESPONSE"
    return 1
  elif [ "$size" -lt 5000 ]; then
    echo "🔴 $url - TOO SMALL (${size}B)"
    return 1
  elif [ -n "$expected" ] && ! echo "$title" | grep -qi "$expected"; then
    echo "🔴 $url - WRONG TITLE: $title"
    return 1
  fi
  return 0
}

issues=0

# Core pages
check_page "$BASE/" "Dog Training Online" || ((issues++))
check_page "$BASE/faq" "Frequently Asked Questions" || ((issues++))
check_page "$BASE/about" "About Us" || ((issues++))
check_page "$BASE/contact" "Contact Us" || ((issues++))

# Course pages
check_page "$BASE/courses/puppy" "Puppy Raising" || ((issues++))
check_page "$BASE/courses/kids" "Dogs for Kids" || ((issues++))
check_page "$BASE/courses/adoption" "Adopt the Right Dog" || ((issues++))
check_page "$BASE/courses/positive" "Positive-Only" || ((issues++))
check_page "$BASE/courses/balanced" "Balanced Training" || ((issues++))
check_page "$BASE/courses/breeds" "Breed-Specific" || ((issues++))

# Blog posts
check_page "$BASE/blog/puppy-training-schedule" "Puppy Training Schedule" || ((issues++))
check_page "$BASE/blog/puppy-first-week" "First 7 Days" || ((issues++))
check_page "$BASE/blog/positive-vs-balanced-training" "Positive-Only vs Balanced" || ((issues++))
check_page "$BASE/blog/dog-body-language-guide" "Dog Body Language" || ((issues++))
check_page "$BASE/blog/how-to-train-a-puppy" "How to Train a Puppy" || ((issues++))
check_page "$BASE/blog/separation-anxiety-dogs" "Separation Anxiety" || ((issues++))
check_page "$BASE/blog/leash-pulling-solutions" "Leash Pulling" || ((issues++))

# Sitemap
sitemap_count=$(curl -sL "$BASE/sitemap.xml" 2>/dev/null | grep -c '<loc>')
if [ "$sitemap_count" -lt 18 ]; then
  echo "🔴 sitemap - only $sitemap_count URLs"
  ((issues++))
fi

if [ "$issues" -eq 0 ]; then
  echo "✅ All green - $sitemap_count URLs in sitemap"
  exit 0
else
  echo "🔴 $issues issues found"
  exit 1
fi