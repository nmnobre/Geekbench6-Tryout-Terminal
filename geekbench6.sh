if ! command -v wget &> /dev/null && ! command -v curl &> /dev/null
then
    echo "Neither wget nor curl were found. Please install one of them."
    exit
fi

url=$(./geekbench6 | grep "claim?key" -m 1 | sed -e 's/^[ \t]*//')
url_trim=$(echo $url | sed -e 's/claim.*//')

if command -v wget &> /dev/null
then
    SC=$(wget --no-check-certificate -O - $url_trim 2>&1 | grep -e "Single-Core Score" -B 1 -m 1 | sed -r 's/.*>([0-9]*)<.*/\1/' | head -n 1)
    MC=$(wget --no-check-certificate -O - $url_trim 2>&1 | grep -e "Multi-Core Score" -B 1 -m 1 | sed -r 's/.*>([0-9]*)<.*/\1/' | head -n 1)
elif command -v curl &> /dev/null
then
    SC=$(curl -k $url_trim 2>&1 | grep -e "Single-Core Score" -B 1 -m 1 | sed -r 's/.*>([0-9]*)<.*/\1/' | head -n 1)
    MC=$(curl -k $url_trim 2>&1 | grep -e "Multi-Core Score" -B 1 -m 1 | sed -r 's/.*>([0-9]*)<.*/\1/' | head -n 1)
fi

echo $url
echo "Single-Core Score:" $SC
echo "Multi-Core Score:" $MC
