#coding: utf-8
require 'punycode'

Plugin.create(:postbox_punyencode) do
  def encode(s)
    #アスキー文字列と非アスキー文字列で分けてそれにmapかける
    s.scan(/[[:ascii:]]+|[^[:ascii:]]+/).map do |s|
      if s.ascii_only?
        s
      else
        "xn--#{ Punycode.encode(s) }"
      end
    end.join
  end

  command(:be_punycode,
          name: 'PunyCode化',
          condition: lambda{|_| true },
          visible: true,
          role: :postbox
         ) do |opt|
           # postboxからメッセジ拾う
           message = Plugin[:gtk].widgetof(opt.widget).widget_post.buffer.text
           # ぷに!コード変換
           str = encode message
           # postbox書き込み
           Plugin[:gtk].widgetof(opt.widget).widget_post.buffer.text = str
         end
end
