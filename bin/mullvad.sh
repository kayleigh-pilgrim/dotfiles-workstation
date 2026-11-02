#!/usr/bin/env bash

# Choose a Mullvad exit node through Tailscale.

for command in tailscale jq sudo; do
    if ! command -v "$command" >/dev/null 2>&1; then
        printf 'Error: %s is not installed.\n' "$command" >&2
        exit 1
    fi
done

echo "Choose a Tailscale exit node:"
echo

PS3="Enter a number: "

select choice in \
    "No Mullvad VPN" \
    "Belgium" \
    "Netherlands" \
    "United States" \
    "United Kingdom" \
    "Canada" \
    "France" \
    "Finland" \
    "Ukraine" \
    "Hong Kong" \
    "Singapore" \
    "Thailand" \
    "Brazil" \
    "Australia" \
    "South Africa" \
    "Quit"
do
    case "$choice" in
        "No Mullvad VPN")
            if sudo tailscale set --exit-node=; then
                echo "Exit node disabled. Tailscale remains connected."
                exit 0
            else
                echo "Could not disable the exit node." >&2
                exit 1
            fi
            ;;
        "Belgium")        country_code="BE" ;;
        "Netherlands")    country_code="NL" ;;
        "United States")  country_code="US" ;;
        "United Kingdom") country_code="GB" ;;
        "Canada")         country_code="CA" ;;
        "France")         country_code="FR" ;;
        "Finland")        country_code="FI" ;;
        "Ukraine")        country_code="UA" ;;
        "Hong Kong")      country_code="HK" ;;
        "Singapore")      country_code="SG" ;;
        "Thailand")       country_code="TH" ;;
        "Brazil")         country_code="BR" ;;
        "Australia")      country_code="AU" ;;
        "South Africa")   country_code="ZA" ;;
        "Quit")
            echo "No changes made."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please enter a number from the menu."
            continue
            ;;
    esac

    if ! status=$(tailscale status --json); then
        echo "Could not get Tailscale status. Is tailscaled running?" >&2
        exit 1
    fi

    if ! jq -e '.BackendState == "Running"' <<< "$status" >/dev/null; then
        echo "Tailscale is not connected. Check 'tailscale status'." >&2
        exit 1
    fi

    # Choose the highest-priority online Mullvad node in the country.
    if ! node=$(jq -r --arg country "$country_code" '
        [
            (.Peer // {} | .[])
            | select(.ExitNodeOption == true and .Online == true)
            | select((.Location.CountryCode // "" | ascii_upcase) == $country)
            | select((.DNSName // "" | rtrimstr(".") | endswith(".mullvad.ts.net")))
            | select((.TailscaleIPs // []) | length > 0)
        ]
        | sort_by(-(.Location.Priority // 0), .DNSName)
        | .[0]
        | if . == null then empty
          else [.TailscaleIPs[0], .DNSName, (.Location.City // "Unknown")]
               | @tsv
          end
    ' <<< "$status"); then
        echo "Could not read the Tailscale status data." >&2
        exit 1
    fi

    if [[ -z "$node" ]]; then
        echo "No online Mullvad exit node found for $choice." >&2
        echo "Check your Mullvad access and 'tailscale exit-node list'." >&2
        exit 1
    fi

    IFS=$'\t' read -r ip hostname city <<< "$node"
    echo "Selecting $choice — $city ($hostname, $ip)..."

    if sudo tailscale set --exit-node="$ip"; then
        echo "Exit node selected. Check it with: tailscale status"
        exit 0
    else
        echo "Could not select the exit node." >&2
        exit 1
    fi
done

echo "No changes made."
