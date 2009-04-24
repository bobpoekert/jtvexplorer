class Hash
  
  def keys_sorted_by_value(options = Hash.new, &block)
    limit = options[:limit] || size
    offset = options[:offset] || 0
    
    sorted = map.sort_by do |key, value|
      if block
        yield(key, value)
      else
        value
      end
    end
    
    sorted.reverse! if options[:reverse]
    
    sorted.map {|key, value| key}.slice(offset, limit) || Array.new
  end
  
  def pick_weighted
    sort_by {|k, w| w.to_f * rand}.reverse.first.first
  end
  
  def hmap(options=Hash.new)
    h = Hash.new
    keys.each do |k|
      if options[:alter_keys]
        result = yield k, self[k]
        if result
          key, value = result
          h[key] = value
        end
      else
        result = yield self[k]
        h[k] = result
      end
    end
    h
  end
  
  def remove(hash)
    reject {|k, v| hash[k] == v}
  end

  def compact
    reject {|k,v| v.nil? }
  end
  
  def replace_values(hash)
    h = dup
    h.each {|k, v| h[k] = hash[k] if hash.has_key?(k)}
  end
  
  def subset?(hash)
    hash.map {|k, v| self[k] == v}.all?
  end

  def slice!(*keys)
    keys = keys.flatten
    delete_if {|k,v| !keys.include?(k)}
  end
  
  def to_params(prefix='')
    map do |k,v|
      if v.is_a?(Hash)
        v.to_params(k.to_s)
      elsif !prefix.blank?
        CGI::escape("#{prefix}[#{k.to_s}]") + "=#{CGI::escape v.to_s}"
      else
        "#{CGI::escape k.to_s}=#{CGI::escape v.to_s}"
      end
    end.join('&')
  end
end

require 'iconv'

class String
  def titlecase
    gsub(/\b\w/) {$&.upcase}
  end
  
  UTF_ICV = Iconv.new('UTF-8//IGNORE', 'UTF-8')
  def utf8safe
    UTF_ICV.iconv(self + ' ')[0..-2]
  end
end

class Object  
  def maybe(*args)
    send(*args) unless nil? 
  end
end

class Hash
  def get(k)
    self[k]
  end
end

class NilClass
  def get(k)
    nil
  end
end

class Array
  def %(field)
    map {|o| o.send(field)}
  end
  
  def percent_map
    i = 0.0
    percent = 0
    map do |item|
      i += 1.0
      if i > percent * size
        puts "#{(percent * 100).round}%"
        if size > 100
          percent += 0.01
        end
      end
      yield(item)
    end
  end
  
  def parallel_each(thread_pool_size=10, timeout=30)
    items = dup
    threads = Array.new
    thread_pool_size.times do
      threads << Thread.new do
        while true
          item = items.pop
          if item 
            yield(item)
          else
            break
          end
        end
      end
    end
    begin
      Timeout::timeout(timeout) do
        threads.each {|t| t.join}
      end
    rescue Timeout::Error
      nil
    end
    self
  end
  
  # options is a hash of fields to required values
  # nil values are wildcards, matching everything
  def find_matching(options)
    find_all {|x| options.map {|k, v| v.nil? || x.send(k) == v}.all?}
  end
  
  def count_by
    inject(Hash.new(0)) do |counts, element|
      counts[yield(element)] += 1
      counts
    end
  end
  
  def product(arr)
    ret = []

    each do |x|
      arr.each do |y|
        ret << (block_given? ? yield(x, y) : [x, y])
      end
    end
    
    ret
  end
  
  def cycle(i)
    i = i % size
    self[i..size] + self[0...i]
  end
  
  def center_first
    centered = Array.new
    last_pushed = false
    each do |x|
      centered.push(x) unless last_pushed
      centered.unshift(x) if last_pushed
      last_pushed = !last_pushed
    end
    centered
  end
   
  def random_subset(n=size)
    shuffle.slice(0, n)
  end
  
  def random
    self[rand(size)]
  end
  
  def shuffle
    sort_by { rand }
  end
   
  def uniqb
    seen = Hash.new
    inject(Array.new) do |arr, x|
      v = yield(x)
      if !seen[v]
        arr << x
        seen[v] = true
      end
      arr
    end
  end
   
  def divide
    evens = Array.new
    odds = Array.new
    each_with_index do |x, i|
      if i % 2 == 0
        evens << x
      else
        odds << x
      end
    end
    [evens, odds]
  end
   
  def remove!(*items)
    items.each {|item| reject! {|x| x == item}}
    self
  end
   
  def remove(*items)
    dup.remove!(*items)
  end
   
  def avg
    return 0 if size.zero?
    sum / size.to_f
  end
  
  def hash_as
    h = Hash.new
    each {|x| h[x] = yield(x)}
    h
  end 

  def subset?(arr)
    map {|x| arr.include?(x)}.all?
  end
end

require 'date'

class Time
  def next_quarter_hour
    return self if min % 15 == 0
    self + (15 - (min % 15)).minutes - sec.seconds
  end

  def prev_quarter_hour
    return self if min % 15 == 0
    self - (min % 15).minutes - sec.seconds
  end

  def prev_hour
    self - min.minutes - sec.seconds
  end
end

class DateTime
  def to_date
    Date.new year, month, day
  end
end
