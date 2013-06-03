require '../lib/sudoku'
require '../lib/cell'
require 'minitest/autorun'
require 'ruby-debug'

class SudokuTest < Minitest::Test

  def setup
    @sudoku = Sudoku.new '015003002000100906270068430490002017501040380003905000900081040860070025037204600'
    @cells = @sudoku.send(:cells)
  end

  def test_we_dont_go_into_infinite_loop
    sudoku = Sudoku.new('0' * 81)
    sudoku.solve!
    refute sudoku.solved?
  end

  def test_splitting_input_into_cells    
    assert_equal 81, @cells.length
    assert @cells.all?{|c| c.is_a? Cell}
  end

  def test_boxes_are_generated_correctly
    rows = (0..80).map {|i| Cell.new(i)}.each_slice(9).to_a    
    boxes = @sudoku.send(:boxes, rows)
    assert_equal 9, boxes.length    
    boxes.each do |box|
      assert_equal 9, box.length
      assert box.all? {|c| c.is_a? Cell}
    end
  end

  def test_cells_have_references_to_corresponding_sets    
    @cells.each do |c| 
      assert_equal 3, c.slices.length
      c.slices.each do |slice| 
        assert slice.is_a?(Array)
        assert_equal 9, slice.length
        slice.each do |cell|
          assert 3, cell.slices.length
        end
      end
    end
  end

  def test_sudoku_can_be_solved        
    refute @sudoku.solved?    
    @sudoku.solve!    
    assert @sudoku.solved?
    assert_equal '615493872348127956279568431496832517521746389783915264952681743864379125137254698', @cells.map(&:value).join
  end

end