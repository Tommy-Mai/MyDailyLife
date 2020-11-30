# frozen_string_literal: true

json.id @task_comment.id
json.task_id @task_comment.task_id
json.created_at @task_comment.created_at
json.comment @task_comment.comment unless @task_comment.comment.nil?
json.image url_for(@task_comment.image) if @task_comment.image.attached?
