#!/bin/bash



phonebook="phonebook.txt"


if [ "$#" -ne 2 ]; 
    then
    echo "잘못된 입력입니다." 
    exit 1
fi


number=$2
if [[ ! $number =~ ^[0-9-]+$ ]]; 
    then
    echo "잘못된 전화번호 형식입니다. 숫자와 하이픈(-)만 사용할 수 있습니다."
    exit 1
fi

name=$1

phone_number=$(grep "^$name" "$phonebook" | cut -d ' ' -f2)

if [ -n "$phone_number" ]; 
    then
    echo "$name님의 전화번호는 $phone_number입니다."
    exit 1
fi


region_number=(
    ["02"]="서울"
    ["031"]="경기"
    ["032"]="인천"
    ["033"]="강원"
    ["042"]="대전"
    ["044"]="세종"
    ["051"]="부산"
    ["054"]="경북"
    ["053"]="대구"
    ["061"]="전남"
    ["062"]="광주"
    ["063"]="전북"
    ["064"]="제주"
    
)


if [[ ${number:0:3} = 010 ]]; 
    then
    region="휴대폰"
else

    region_code=$(echo "$number" | cut -d'-' -f1)

    
    region="${region_number[$region_code]}"
    
    if [ -z "$region" ]; 
    then
        echo "지역번호 $region_code에 해당하는 지역 정보를 찾을 수 없습니다."
     exit 1
    fi
fi


temp_file=$(mktemp)
echo "$name $number $region" > "$temp_file"
sed -i '/^$/d' "$phonebook"
cat "$phonebook" >> "$temp_file"
LC_COLLATE=ko_KR.UTF-8 sort -o "$phonebook" -k1,1 "$temp_file"
rm "$temp_file"
echo "$name님의 전화번호가 추가되었습니다."