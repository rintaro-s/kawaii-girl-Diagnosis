# image_tags.ps1

# タグのリストを定義s
$tags = @{
    1 = @('眼鏡', '少女', '巨乳', '清楚')
    2 = @('貧乳', 'お姉さん', 'ロングヘア', '活発')
    3 = @('ショートヘア', '美少女', 'クール', 'スタイル抜群')
    4 = @('ポニーテール', '色白', 'おっとり', '健康的')
    5 = @('普通', '大人っぽい', 'ツンデレ', 'かわいい')
    6 = @('セーラー服', '元気', 'おとなしい', 'ドジっ子')
    7 = @('眼鏡', '貧乳', 'セーラー服', 'お姉さん')
    8 = @('巨乳', 'ロングヘア', '清楚', '美少女')
    9 = @('活発', 'ショートヘア', 'おっとり', '色白')
    10 = @('クール', 'スタイル抜群', '普通', 'ツンデレ')
    11 = @('健康的', 'ポニーテール', 'お姉さん', '大人っぽい')
    12 = @('貧乳', '元気', 'ドジっ子', '眼鏡')
    13 = @('美少女', 'おっとり', 'セーラー服', '少女')
    14 = @('巨乳', 'クール', 'ロングヘア', '活発')
    # 15 = @('清楚', 'スタイル抜群', '普通', 'おとなしい')
    # 16 = @('ツンデレ', '色白', 'ポニーテール', 'ドジっ子')
    # 17 = @('健康的', '貧乳', 'ショートヘア', 'セーラー服')
    # 18 = @('お姉さん', '美少女', '巨乳', '元気')
    # 19 = @('クール', 'ツンデレ', '清楚', 'おっとり')
    # 20 = @('スタイル抜群', 'ロングヘア', '少女', 'ドジっ子')
    # 21 = @('活発', '眼鏡', '大人っぽい', 'おとなしい')
    # 22 = @('色白', '普通', 'ポニーテール', 'お姉さん')
    # 23 = @('貧乳', 'クール', '美少女', 'セーラー服')
    # 24 = @('巨乳', '元気', 'ショートヘア', 'ツンデレ')
    # 25 = @('おっとり', '健康的', 'セーラー服', 'ロングヘア')
    # 26 = @('スタイル抜群', 'お姉さん', '普通', 'ドジっ子')
    # 27 = @('眼鏡', '少女', '活発', '清楚')
    # 28 = @('貧乳', '巨乳', '美少女', '元気')
    # 29 = @('ツンデレ', 'おっとり', 'ロングヘア', 'セーラー服')
    # 30 = @('クール', 'ショートヘア', '普通', '健康的')
}

# CSVファイルパス
$outputPath = ".\tags\tags.csv"

# CSVに書き込み
$tags.GetEnumerator() | ForEach-Object {
    [PSCustomObject]@{
        ImageNumber = $_.Key
        Tags = ($_.Value -join ',')
    }
} | Export-Csv -Path $outputPath -NoTypeInformation
