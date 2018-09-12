module GameMatrix
  def normalize_character(character_type)
    case character_type[:character_type]
    when O
      O_MATRIX
    when I
      chose_i(character_type[:rotate])
    when J
      chose_j(character_type[:rotate])
    when L
      chose_l(character_type[:rotate])
    when S
      chose_s(character_type[:rotate])
    when T
      chose_t(character_type[:rotate])
    when Z
      chose_z(character_type[:rotate])
    end
  end

  def original_character(check_sign)
    case check_sign
    when I
      I_MATRIX
    when J
      J_MATRIX
    when L
      L_MATRIX
    when O
      O_MATRIX
    when S
      S_MATRIX
    when T
      T_MATRIX
    when Z
      Z_MATRIX
    end
  end

  def chose_i(rotate)
    case rotate
    when NORMAL_TYPE
      [
        [1, 1, 1, 1]
      ]
    when FLIP_180_TYPE
      [
        [1, 1, 1, 1]
      ]

    when FLIP_90_TYPE
      [
        [1],
        [1],
        [1],
        [1]
      ]
    when FLIP_270_TYPE
       [
        [1],
        [1],
        [1],
        [1]
      ]
    end
  end

  def chose_j(rotate)
    case rotate
    when NORMAL_TYPE
      [
        [1, 0, 0],
        [1, 1, 1],
      ]
    when FLIP_90_TYPE
      [
        [1, 1],
        [1, 0],
        [1, 0]
      ]
    when FLIP_180_TYPE
     [
        [1, 1, 1],
        [0, 0, 1],
      ]
    when FLIP_270_TYPE
      [
        [0, 1],
        [0, 1],
        [1, 1]
      ]
    end
  end

  def chose_l(rotate)
    case rotate
    when NORMAL_TYPE
      [
        [0, 0, 1],
        [1, 1, 1]
      ]
    when FLIP_90_TYPE
      [
        [1, 0],
        [1, 0],
        [1, 1]
      ]
    when FLIP_180_TYPE
     [
        [1, 1, 1],
        [1, 0, 0],
      ]
    when FLIP_270_TYPE
      [
        [1, 1],
        [0, 1],
        [0, 1]
      ]
    end
  end

  def chose_s(rotate)
    case rotate
    when NORMAL_TYPE
      [
        [0, 1, 1],
        [1, 1, 0]
      ]
    when FLIP_180_TYPE
      [
        [0, 1, 1],
        [1, 1, 0]
      ]
    when FLIP_90_TYPE
      [
        [1, 0],
        [1, 1],
        [0, 1]
      ]
    when FLIP_270_TYPE
      [
        [1, 0],
        [1, 1],
        [0, 1]
      ]
    end
  end

  def chose_t(rotate)
    case rotate
    when NORMAL_TYPE
      [
        [0, 1, 0],
        [1, 1, 1],
      ]
    when FLIP_90_TYPE
      [
        [1, 0],
        [1, 1],
        [1, 0]
      ]
    when FLIP_180_TYPE
     [
        [1, 1, 1],
        [0, 1, 0],
      ]
    when FLIP_270_TYPE
      [
        [0, 1],
        [1, 1],
        [0, 1]
      ]
    end
  end
 
  def chose_z(rotate)
    case rotate
    when NORMAL_TYPE
      [
        [1, 1, 0],
        [0, 1, 1],
      ]
     when FLIP_180_TYPE
      [
        [1, 1, 0],
        [0, 1, 1],
      ]
    when FLIP_90_TYPE
      [
        [0, 1],
        [1, 1],
        [1, 0]
      ]
    when FLIP_270_TYPE
      [
        [0, 1],
        [1, 1],
        [1, 0]
      ]
    end
  end
end














