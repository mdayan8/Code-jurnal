#!/bin/bash

# Test script for realistic contribution patterns
# This simulates the GitHub Actions workflow locally

echo "🧪 Testing realistic contribution patterns..."

# Set up git config
git config --global user.name "mdayan8"
git config --global user.email "mdayanbag@gmail.com"

# Function to simulate activity decision
simulate_day() {
    local test_date=$1
    local day_of_week=$(date -d "$test_date" +%w)
    local day_of_month=$(date -d "$test_date" +%d)
    local month=$(date -d "$test_date" +%m)
    local year=$(date -d "$test_date" +%Y)
    
    # Create seed for pseudo-randomness (handle leading zeros)
    local month_num=$((10#$month))
    local day_num=$((10#$day_of_month))
    local seed=$((year + month_num * 31 + day_num * 7 + day_of_week))
    local random_num=$((seed % 100))
    
    echo "📅 Testing $test_date (random: $random_num)"
    
    # Apply realistic patterns
    if [ $random_num -lt 40 ]; then
        echo "  🚫 NO ACTIVITY - Realistic gap day"
        return 1  # Skip
    elif [ $random_num -lt 75 ]; then
        echo "  📝 LOW Activity - Light work day"
        return 2  # Low
    elif [ $random_num -lt 95 ]; then
        echo "  💼 MEDIUM Activity - Regular work day"
        return 3  # Medium
    else
        echo "  🚀 HIGH Activity - Productive day"
        return 4  # High
    fi
}

# Function to simulate commits
make_test_commits() {
    local activity_level=$1
    local test_date=$2
    local commit_count=1
    
    case $activity_level in
        2) # Low
            echo "    Making 1 commit..."
            commit_count=1
            ;;
        3) # Medium
            echo "    Making 3 commits..."
            commit_count=3
            ;;
        4) # High
            echo "    Making 5 commits..."
            commit_count=5
            ;;
    esac
    
    # Simulate the commit creation
    echo "🕒 $test_date - simulated activity (level: $activity_level)" >> daily.md
    echo "    ✅ Would create $commit_count commits"
    
    # Simulate direct push vs PR decision
    local method_random=$((RANDOM % 10))
    if [ $method_random -lt 6 ]; then
        echo "    🔀 Would PUSH directly to main"
    else
        echo "    📋 Would create PULL REQUEST"
    fi
}

# Test the pattern for the next 30 days
echo ""
echo "🗓️  Simulating next 30 days of activity patterns:"
echo "================================================"

total_days=30
active_days=0
direct_pushes=0
pull_requests=0

for i in $(seq 0 $((total_days-1))); do
    test_date=$(date -d "+$i days" +%Y-%m-%d)
    
    simulate_day "$test_date"
    activity_level=$?
    
    if [ $activity_level -gt 1 ]; then
        active_days=$((active_days + 1))
        make_test_commits $activity_level "$test_date"
        
        # Count method simulation
        method_random=$((RANDOM % 10))
        if [ $method_random -lt 6 ]; then
            direct_pushes=$((direct_pushes + 1))
        else
            pull_requests=$((pull_requests + 1))
        fi
    fi
    
    echo ""
done

# Show statistics
echo "📊 Pattern Statistics for $total_days days:"
echo "==========================================="
echo "Active days: $active_days/$total_days ($((active_days * 100 / total_days))%)"
echo "Inactive days: $((total_days - active_days))/$total_days ($(((total_days - active_days) * 100 / total_days))%)"
echo "Direct pushes: $direct_pushes ($([ $active_days -gt 0 ] && echo $((direct_pushes * 100 / active_days)) || echo 0)% of active days)"
echo "Pull requests: $pull_requests ($([ $active_days -gt 0 ] && echo $((pull_requests * 100 / active_days)) || echo 0)% of active days)"

echo ""
echo "✅ Test simulation complete!"
echo "This shows what the realistic pattern would look like."
echo "Actual contributions will vary but follow similar patterns."