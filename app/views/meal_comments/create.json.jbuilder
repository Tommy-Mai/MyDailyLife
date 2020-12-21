# frozen_string_literal: true

json.id @meal_comment.id
json.task_id @meal_comment.task_id
json.created_at @meal_comment.created_at
json.comment @meal_comment.comment unless @meal_comment.comment.nil?
json.image url_for(@meal_comment.image) if @meal_comment.image.attached?
