#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_edit_and_capture.sh"

chat_query() {
	if [ -z "$OPENAI_API_KEY" ]; then
		printf "OPENAI_API_KEY is not set!\n"
		exit 1
	fi
	MODEL=${MODEL:-$DEFAULT_MODEL} # gpt-4-32k, gpt-4, gpt-4-1106-preview

	CONTENT="$*" # Prepend prompt

	# If STDIN is a terminal (keyboard input) and there is no content, prompt for more input
	if [ -t 0 ]; then # STDIN is a terminal (keyboard input)
		if [ -z "$CONTENT" ]; then
			edit_and_capture BODY
			printf "Prompt: %s\n" "$BODY"
		fi
	else # "STDIN is piped or redirected from a different source"
		BODY="$(cat)"
	fi

	CONTENT="$CONTENT$BODY"

	raw_response=$(jq -n --arg MODEL "$MODEL" --arg CONTENT "$CONTENT" '
{
	"model": $MODEL,
	"messages": [
	{
		"role": "user",
		"content": $CONTENT
	}
	]
}' | curl -s https://api.openai.com/v1/chat/completions \
		-H "Authorization: Bearer $OPENAI_API_KEY" \
		-H "Content-Type: application/json" \
		-d @-)

	resp=$(printf "%s" "$raw_response" | jq -r '.choices[0].message.content')

	if [ "$resp" = 'null' ]; then
		printf "%s" "$raw_response" | jq
	else
		printf "%s" "$resp" | glow
	fi
}
