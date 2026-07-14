def get_col(arr, c)
  res = []
  
  arr.length.times do |i|
    res << arr[i][c]
  end
  
  return res
end

def get_col_from_down(arr, c)
  res = []
  
  arr.length.times do |i|
    res << arr[(arr.length - 1) - i][c]
  end
  
  return res
end

def duparr(arr, p)
  res = 0
    
  arr.length.times do |i|
    if (arr[i].x == p.x && arr[i].y == p.y)
      res += 1
    end
  end
    
  return res
end
  
def arr_empty_count(arr, args)
  res = 0
    
  arr.length.times do |i|
    if arr[i] == args.state.themes.empty_id
      res += 1
    end
  end
  
  return res
end

def arr_purify(arr, args)
  res = []
  z = arr_empty_count(arr, args)
    
  arr.length.times do |i|
    if (arr[i] != args.state.themes.empty_id)
      res << arr[i]
    end
  end
  
  z.times do |i|
    res << args.state.themes.empty_id
  end
    
  return res
end
  
def purify_col(arr, n, args)
  return arr_purify(get_col_from_down(arr, n), args)
end

def arr_no_conflict(arr1, arr2)
  if (arr1.length != arr2.length)
    return false
  else
    res = 0
    
    arr1.length.times do |i|
      if (arr1[i] != arr2[i])
        res += 1
      end
    end
    
    return (res == arr1.length)
  end
end

def no_rows_conflict args
  res = 0
    
  args.state.metadata.grid.length.times do |i|
    if (arr_no_conflict(args.state.metadata.grid[i], (i == args.state.metadata.grid.length - 1) ? args.state.metadata.grid[i] : args.state.metadata.grid[i + 1]))
      res += 1
    end
  end
  
  return (res == args.state.metadata.grid.length - 1)
end

def no_cols_conflict args
  res = 0
    
  args.state.metadata.grid.length.times do |i|
    if (arr_no_conflict(get_col(args.state.metadata.grid, i), (i == args.state.metadata.grid.length - 1) ? get_col(args.state.metadata.grid, i) : get_col(args.state.metadata.grid, i + 1)))
      res += 1
    end
  end
  
  return (res == args.state.metadata.grid.length - 1)
end

def no_moves(args)
  return (no_cols_conflict(args) && no_rows_conflict(args))
end

def correct_col(c, args)
  args.state.metadata.grid.length.times do |i|
    idx = (args.state.metadata.grid.length - 1) - i
    
    if args.state.metadata.grid[idx][c] == args.state.themes.empty_id
      args.state.metadata.grid[idx][c] = rand_piece
    end
  end
end
