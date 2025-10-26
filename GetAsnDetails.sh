#!/bin/bash

# Input: domain list (from stdin or file)
# Output: ASN prefix + description

while read -r domain || [[ -n "$domain" ]]; do
    ip=$(dig +short "$domain" | grep -E '^[0-9.]+$' | head -n1)
    
    if [[ -z "$ip" ]]; then
        echo "❌ Failed to resolve IP for $domain" >&2
        continue
    fi

    asn=$(curl -s "https://api.bgpview.io/ip/$ip" | jq -r '.data.asn')

    if [[ "$asn" == "null" || -z "$asn" ]]; then
        echo "❌ ASN not found for IP $ip ($domain)" >&2
        continue
    fi

    curl -s "https://api.bgpview.io/asn/$asn/prefix" \
    | jq -r --arg domain "$domain" '.data.ipv4_prefixes[0] | "\($domain): \(.prefix) \(.description)"'
done < "${1:-/dev/stdin}"
