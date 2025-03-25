puts 'Creating admin user...'
Administrator.create_with(password: 'admin')
  .find_or_create_by!(name: 'admin')

# 添加常见广告词数据
puts 'Adding spam words...'

# 赌博类广告词
puts 'Adding gambling spam words...'
gambling_words = [
  '网赌', '菠菜', '博彩', '赌场', '网上赌场', '网络赌博', 
  '百家乐', '真人娱乐', '投注平台', '体育博彩', '赌博网站',
  '线上娱乐', '现金投注', '真钱游戏', '棋牌游戏', '老虎机',
  '彩票网站', '六合彩', '赌钱', '赌博'
]

gambling_words.each_with_index do |word, index|
  SpamWord.find_or_create_by(word: word) do |spam_word|
    spam_word.replacement = '***'
    spam_word.active = true
  end
  print '.' if (index % 5) == 0
end
puts ' 完成!'

# 药品类广告词
puts 'Adding medicine spam words...'
medicine_words = [
  '伟哥', '壮阳药', '减肥药', '催情药', '增高药', '减肥产品',
  '壮阳', '补肾', '增大', '丰胸', '美容针', '抗衰老',
  '延时药', '处方药非法销售', '禁药', '兴奋剂', '激素药',
  '代购药', '走私药', '仿制药', '海外药'
]

medicine_words.each_with_index do |word, index|
  SpamWord.find_or_create_by(word: word) do |spam_word|
    spam_word.replacement = '***'
    spam_word.active = true
  end
  print '.' if (index % 5) == 0
end
puts ' 完成!'

# 色情类广告词
puts 'Adding adult content spam words...'
adult_words = [
  '一夜情', '特殊服务', '上门服务', '找小姐', '找美女', '援交',
  '包夜', '成人内容', '色情网站', '情色', '裸聊', '激情视频',
  '成人直播', '成人电影', '成人交友', '按摩服务', '男公关',
  '特殊按摩', 'sm服务', '伴游'
]

adult_words.each_with_index do |word, index|
  SpamWord.find_or_create_by(word: word) do |spam_word|
    spam_word.replacement = '***'
    spam_word.active = true
  end
  print '.' if (index % 5) == 0
end
puts ' 完成!'

# 金融理财类广告词
puts 'Adding financial spam words...'
financial_words = [
  '贷款', '低息贷款', '无抵押贷款', '小额贷款', '快速放款',
  '身份证贷款', '网贷', '民间借贷', '高额回报', '投资理财',
  '股票内幕', '股市暴利', '基金收益', '期货交易', '虚拟币',
  '挖矿', '炒币', '区块链投资', '互联网金融', '短期高回报'
]

financial_words.each_with_index do |word, index|
  SpamWord.find_or_create_by(word: word) do |spam_word|
    spam_word.replacement = '***'
    spam_word.active = true
  end
  print '.' if (index % 5) == 0
end
puts ' 完成!'

# 诈骗信息类广告词
puts 'Adding scam spam words...'
scam_words = [
  '中奖通知', '抽中大奖', '免费领取', '免单', '免费送',
  '兼职刷单', '轻松赚钱', '日赚千元', '零投资', '高薪招聘',
  '加微信有惊喜', '信用卡代还', '黑客服务', '消除征信',
  '刷信誉', '代办证件', '买卖账号', '个人信息', '银行流水', '假发票'
]

scam_words.each_with_index do |word, index|
  SpamWord.find_or_create_by(word: word) do |spam_word|
    spam_word.replacement = '***'
    spam_word.active = true
  end
  print '.' if (index % 5) == 0
end
puts ' 完成!'

puts "已创建 #{SpamWord.count} 个广告词"