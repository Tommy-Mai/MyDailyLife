require 'test_helper'

class MealTasksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get meal_tasks_index_url
    assert_response :success
  end

  test "should get show" do
    get meal_tasks_show_url
    assert_response :success
  end

  test "should get new" do
    get meal_tasks_new_url
    assert_response :success
  end

  test "should get edit" do
    get meal_tasks_edit_url
    assert_response :success
  end

end
