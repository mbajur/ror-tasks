class TodoList

  def initialize(items=[])
    if items.nil?
      raise IllegalArgument
    end
    @list = items
    @completed = []
  end

  def empty?
    @list.empty?
  end

  def size
    @list.size
  end

  def << (item)
    @list << item
    @list
  end

  def last
    @list.last
  end

  def completed? (item)
    @list.include? [item, true]
  end

  def first
    @list.first
  end

  def complete(index)
    @completed[index] = true
  end
end
