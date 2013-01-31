Given /^I am not yet playing$/ do
  @puzzle = Puzzle.new()
end

When /^I start a new game$/ do
  @puzzle.init_pack
end

Then /^Game stage is created$/ do
  @stage = @puzzle.init_stage
end


