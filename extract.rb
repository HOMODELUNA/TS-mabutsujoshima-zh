require "json"
class String
	def has_chinese?
		self =~ /[\u4E00-\u9FA5\uF900-\uFA2D]/
	end
end

def extract(x,former=[],&block)
	case x
	when Hash
		x.each do |k,v|
			extract(v,former+[k],&block)
		end
	when Array
		x.each_with_index do |v,k|
			extract(v,former+[k],&block)
		end
	when String
		if x.has_chinese?
			yield x,former
		end
	end
end

require 'csv'
Dir.glob('*.json').each do |filename|
	j = JSON.parse(IO.read(filename))
	CSV.open("extracted/#{filename}.csv","w") do |csv|
		extract(j,[filename]) do |text,position|
			csv << [text,position.join(',')]
		end
	end
end
	









