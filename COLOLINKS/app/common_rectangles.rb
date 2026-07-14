def board_rect args
  return {
    x: 631 - args.state.counters.anmov,
    y: 95,
    w: 6 * 85,
    h: 6 * 85
  }
end

def tile_rect(x, y, args)
  return {
    x: (($board.x + 10) + (x * 85)) - args.state.counters.anmov,
    y: (530 - (y * 85)),
    w: 65,
    h: 65
  }
end

def leavepoint_rect(x, y, args)
  return {
    x: (623 + (x * 85)) - args.state.counters.anmov,
    y: (511 - (y * 85)),
    w: 102,
    h: 102
  }
end

def glow_rect(x, y, args)
  return {
    x: (624 + (x * 85)) - args.state.counters.anmov,
    y: (512 - (y * 85)),
    w: 100,
    h: 100
  }
end

def select_rect(x, y)
  return {
    x: x - 5,
    y: y - 10,
    w: 85,
    h: 85
  }
end

def x_from_board(px, args)
  return (($board.x + 4) + (px * 85)) - args.state.counters.anmov
end

def y_from_board(py)
  return 530 - (py * 85)
end
