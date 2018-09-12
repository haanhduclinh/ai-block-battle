def debug?(object = nil)
  if block_given?
    yield(object)
  else
    ENV["DEBUG"]
  end
end
