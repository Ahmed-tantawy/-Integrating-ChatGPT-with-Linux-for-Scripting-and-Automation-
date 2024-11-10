# Function to interact with ChatGPT API directly from the terminal
function askgpt() {
    # Combine all arguments into a single prompt
    local prompt="$*"
    echo "Sending request to ChatGPT with prompt: $prompt"
    
    # Send the prompt to ChatGPT API and capture the response
    response=$(curl -s -X POST https://api.openai.com/v1/chat/completions \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -d '{
            "model": "gpt-3.5-turbo",
            "messages": [{"role": "user", "content": "'"$prompt"'"}]
        }')

    # Extract and clean up the 'content' field from the response
    content=$(echo "$response" | awk -F'"content":' '{print $2}' \
        | sed 's/^ "//;s/",//g' \
        | sed 's/\\"/"/g' \
        | sed 's/\\n/\n/g' \
        | sed '/^$/d')
    
    # Display the response with line wrapping for readability
    if [ -n "$content" ]; then
        echo -e "$content" | fold -s -w 80
    else
        echo "Failed to parse response from API:"
        echo "$response"
    fi
}
