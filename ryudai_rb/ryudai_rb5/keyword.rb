def keyword(name: "siman" , say: "")
  p name
  p say
  puts "#{name} say #{say}"
end

def non_keyword(operation={})
  p operation[:name] || "Simanman"
  p operation[:say] || "Hello world"
end

keyword(say: "Hello World!", name: "Tamayose")

non_keyword(say: "Hello World!")
