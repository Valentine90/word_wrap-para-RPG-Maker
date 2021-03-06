#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  Esta é a superclasse de todas as janelas do jogo.
#------------------------------------------------------------------------------
#  Autor: Valentine
#==============================================================================

class Window_Base < Window

  def word_wrap(text, width = contents_width)
    # Corrige a compressão de texto do RGD
    width -= 20
    bitmap = contents || Bitmap.new(1, 1)
    return [text] if bitmap.text_size(text).width <= width && !text.include?("\n")
    lines = []
    line = ''
    line_width = 0
    text.each_line(' ') do |word|
      word_width = bitmap.text_size(word).width
      if word.include?("\n")
        line, lines, line_width = skip_line(word, width, bitmap, line, lines, line_width)
      elsif word_width > width
        line, lines = character_wrap(word, width, bitmap, line, lines)
      elsif line_width + word_width <= width
        line << word
        line_width += word_width
      else
        lines << line
        line = word
        line_width = word_width
      end
    end
    bitmap.dispose unless contents
    lines << line
  end
  
  def skip_line(words, width, bitmap, line, lines, line_width)
    words.each_line do |word|
      # Se a última palavra da matriz não está
      #acompanhada do comando de quebra de linha
      unless word.end_with?("\n")
        line = word
        line_width = bitmap.text_size(word).width
        break
      end
      word = word.delete("\n")
      word_width = bitmap.text_size(word).width
      if line_width + word_width <= width
        # Impede que as linhas sejam alteradas quando a
        #linha atual for apagada
        lines << line.clone + word
      else
        lines << line.clone << word
      end
      line.clear
      line_width = 0
    end
    return line, lines, line_width
  end
  
  def character_wrap(word, width, bitmap, line, lines)
    cs = ''
    cs_width = 0
    word.each_char do |c|
      c_width = bitmap.text_size(c).width
      if cs_width + c_width <= width
        cs << c
        cs_width += c_width
      else
        lines << line.clone unless line.empty?
        lines << cs
        cs = c
        cs_width = c_width
        line.clear
      end
    end
    return line << cs, lines
  end
  
end
