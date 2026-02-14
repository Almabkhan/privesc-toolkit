#!/bin/bash
# SUID Binary Checker

echo "==================================="
echo "SUID BINARY CHECKER"
echo "==================================="

# Find all SUID binaries
echo -e "\n[+] SUID Binaries Found:"
find / -perm -4000 2>/dev/null | while read binary; do
    echo "  • $binary"
    
    # Check for common vulnerable SUID binaries
    case "$binary" in
        *"/find")
            echo "    [!] find - potential privesc: find . -exec /bin/sh \; -quit"
            ;;
        *"/nmap")
            echo "    [!] nmap - potential privesc: nmap --interactive"
            ;;
        *"/vim"|*"/vi"|*"/nano")
            echo "    [!] editor - potential privesc: :!sh"
            ;;
        *"/cp"|*"/mv"|*"/rm")
            echo "    [*] file operations - check permissions"
            ;;
    esac
done

echo -e "\n[+] Check complete!"