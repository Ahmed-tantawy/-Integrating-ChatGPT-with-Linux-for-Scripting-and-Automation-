# ChatGPT function to interact with OpenAI API directly from the terminal
function askgpt() {
    # Combine all arguments passed to the function into a single prompt
    local prompt="$*"
    echo "Sending request to ChatGPT with prompt: $prompt"

    
    # Send the prompt to OpenAI API using curl(explained in the readme file)
    response=$(curl -s -X POST https://api.openai.com/v1/chat/completions \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \  # Ensure your API key is stored in $OPENAI_API_KEY
        -d '{
            "model": "gpt-3.5-turbo",
            "messages": [{"role": "user", "content": "'"$prompt"'"}]
        }')

    # Extract the content field from the JSON response using awk and sed
    content=$(echo "$response" | awk -F'"content":' '{print $2}' | sed 's/^ "//;s/",//g' | sed 's/\\"/"/g' | sed 's/\\n/\n/g')

    # Print the response content, or an error message if parsing fails
    if [ -n "$content" ]; then
        echo -e "$content"
    else
        echo "Failed to parse response from API:"
        echo "$response"
    fi
}
