# Todos-API

- [Introduction](#introduction)
    - [Specifications](#specifications)
- [Testing with httpie](#testing-with-httpie)
- [Deployment](#deployment)

## Introduction

A RestAPI which simulates of a to-do list with Ruby on Rails. The functions implemented are below and every action was tested with rspec and httpie.

### Specifications

* OS: Ubuntu 20.04.5 LTS

* Ruby version: `ruby 3.0.2`

* Rails version: `Rails 6.1.7`

* Run the test suite: `bundle exec rspec`

## Testing with httpie

1. Install httpie by running `sudo apt-get install httpie`

1. Start up the rails todos-API 
	```
	ruby bin\rails server
	```

	- API is running on `http://localhost:3000/`

1. Sign up
	```
	http POST :3000/signup name=danae email=dbantana@gmail.com password=12345
	```
	>{  
		"auth_token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2NzQ4NDA5NDV9.YajDEU0O0SL8xJI3Uk6SlzhFanlJbWkonowwA4mPD5Q",  
		"message": "Account created successfully"  
	}  
	
	**Server Response:** User Create (0.3ms)  INSERT INTO "users" ("name", "email", "password_digest", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?)  [["name", "danae"], ["email", "dbantana@gmail.com"], ["password_digest", "$2a$12$YiRDU1.6RxiPbc8F13hpZOLu0rxvQpRWLw5N.RNV7y4u.m1sImH7e"], ["created_at", "2023-01-26 17:35:44.553220"], ["updated_at", "2023-01-26 17:35:44.553220"]]

1. Login in 
	```
	http POST :3000/auth/login email=dbantana@gmail.com password=12345
	```
	>{  
	    "auth_token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2NzQ4NDEwODN9.GCS9nMg_SwOsovM17vkVXn2fesro2QOhYjAjiAZdVcw"  
	}
	
	**Server Response:** User Load (0.2ms)  SELECT "users".* FROM "users" WHERE "users"."email" = ? LIMIT ?  [["email", "dbantana@gmail.com"], ["LIMIT", 1]]

1. Create a todo
	```
	http POST :3000/todos title=myTodo created_by=danae
	```
	> {  
	    "created_at": "2023-01-26T17:54:02.898Z",  
	    "created_by": "danae",  
	    "id": 1,  
	    "title": "myTodo",  
	    "updated_at": "2023-01-26T17:54:02.898Z"  
	}
	
	**Server Response:** Todo Create (0.3ms)  INSERT INTO "todos" ("title", "created_by", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["title", "myTodo"], ["created_by", "danae"], ["created_at", "2023-01-26 17:54:02.898436"], ["updated_at", "2023-01-26 17:54:02.898436"]]

1. Create a todo item (x2)
	```
	http POST :3000/todos/1/items name=item1
	```
	>{  
	    "created_at": "2023-01-26T17:54:02.898Z",  
	    "created_by": "danae",  
	    "id": 1,  
	    "title": "myTodo",  
	    "updated_at": "2023-01-26T17:54:02.898Z"  
	}
	
	**Server Response:** Item Create (0.4ms)  INSERT INTO "items" ("name", "todo_id", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["name", "item1"], ["todo_id", 1], ["created_at", "2023-01-26 17:58:38.778504"], ["updated_at", "2023-01-26 17:58:38.778504"]]
	```
	http POST :3000/todos/1/items name=item2
	```
	>{  
	    "created_at": "2023-01-26T17:54:02.898Z",  
	    "created_by": "danae",  
	    "id": 1,  
	    "title": "myTodo",  
	    "updated_at": "2023-01-26T17:54:02.898Z"  
	}
	
	**Server Response:** Item Create (0.4ms)  INSERT INTO "items" ("name", "todo_id", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["name", "item2"], ["todo_id", 1], ["created_at", "2023-01-26 17:59:45.402064"], ["updated_at", "2023-01-26 17:59:45.402064"]]

1. List todo items
	```
	http GET :3000/todos/1/items
	```
	>[  
	    {  
		"created_at": "2023-01-26T17:58:38.778Z",  
		"done": null,  
		"id": 1,  
		"name": "item1",  
		"todo_id": 1,  
		"updated_at": "2023-01-26T17:58:38.778Z"  
	    },  
	    {  
		"created_at": "2023-01-26T17:59:45.402Z",  
		"done": null,  
		"id": 2,  
		"name": "item2",  
		"todo_id": 1,  
		"updated_at": "2023-01-26T17:59:45.402Z"  
	    }  
	]
	
	**Server Response:** Parameters: {"todo_id"=>"1"} 
	Todo Load (0.2ms)  SELECT "todos".* FROM "todos" WHERE "todos"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]

1. Get a todo item
	```
	http GET :3000/todos/1/items/2
	```
	>{  
	    "created_at": "2023-01-26T17:59:45.402Z",  
	    "done": null,  
	    "id": 2,  
	    "name": "item2",  
	    "todo_id": 1,  
	    "updated_at": "2023-01-26T17:59:45.402Z"  
	}  
	
	**Server Response:** Parameters: {"todo_id"=>"1", "id"=>"2"}
	  Todo Load (0.2ms)  SELECT "todos".* FROM "todos" WHERE "todos"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
	  ↳ app/controllers/items_controller.rb:40:in 'set_todo'
	  Item Load (0.3ms)  SELECT "items".* FROM "items" WHERE "items"."todo_id" = ? AND "items"."id" = ? LIMIT ?  [["todo_id", 1], ["id", 2], ["LIMIT", 1]]
	  ↳ app/controllers/items_controller.rb:44:in 'set_todo_item'

1. Update a todo item
	```
	http PUT :3000/todos/1/items/2 name=itemUpdated
	```
	
	**Server Response:** Item Update (0.3ms)  UPDATE "items" SET "name" = ?, "updated_at" = ? WHERE "items"."id" = ?  [["name", "itemUpdated"], ["updated_at", "2023-01-26 18:10:41.427336"], ["id", 2]]

	```
	http GET :3000/todos/1/items/2
	```
	>{  
	    "created_at": "2023-01-26T17:59:45.402Z",  
	    "done": null,  
	    "id": 2,  
	    "name": "itemUpdated",  
	    "todo_id": 1,  
	    "updated_at": "2023-01-26T18:10:41.427Z"  
	}
	
	**Server Response:**
	Todo Load (0.1ms)  SELECT "todos".* FROM "todos" WHERE "todos"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
	  ↳ app/controllers/items_controller.rb:40:in 'set_todo'
	  Item Load (0.1ms)  SELECT "items".* FROM "items" WHERE "items"."todo_id" = ? AND "items"."id" = ? LIMIT ?  [["todo_id", 1], ["id", 2], ["LIMIT", 1]]
	  ↳ app/controllers/items_controller.rb:44:in 'set_todo_item'

1. Delete a todo item
	```
	http DELETE :3000/todos/1/items/2
	```
	
	**Server Response:**
	Todo Load (0.2ms)  SELECT "todos".* FROM "todos" WHERE "todos"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
	  ↳ app/controllers/items_controller.rb:40:in 'set_todo'
	  Item Load (0.1ms)  SELECT "items".* FROM "items" WHERE "items"."todo_id" = ? AND "items"."id" = ? LIMIT ?  [["todo_id", 1], ["id", 2], ["LIMIT", 1]]
	  ↳ app/controllers/items_controller.rb:44:in 'set_todo_item'
	  Item Destroy (0.3ms)  DELETE FROM "items" WHERE "items"."id" = ?  [["id", 2]]

	```
	http GET :3000/todos/1/items
	```
	>[  
	    {  
		"created_at": "2023-01-26T17:58:38.778Z",  
		"done": null,  
		"id": 1,  
		"name": "item1",  
		"todo_id": 1,  
		"updated_at": "2023-01-26T17:58:38.778Z"  
	    }  
	]

1. Get all todos
	```
	http GET :3000/todos
	```
	>[  
	    {  
		"created_at": "2023-01-26T17:54:02.898Z",  
		"created_by": "danae",  
		"id": 1,  
		"title": "myTodo",  
		"updated_at": "2023-01-26T17:54:02.898Z"  
	    }  
	]
	
	**Server Response:**
	Todo Load (0.2ms)  SELECT "todos".* FROM "todos"

1. Get todo list
	```
	http GET :3000/todos/1
	```
	>{  
	    "created_at": "2023-01-26T17:54:02.898Z",  
	    "created_by": "danae",  
	    "id": 1,  
	    "title": "myTodo",  
	    "updated_at": "2023-01-26T17:54:02.898Z"  
	}
	
	**Server Response:**
	Todo Load (0.2ms)  SELECT "todos".* FROM "todos" WHERE "todos"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]

1. Update a todo
	```
	http PUT :3000/todos/1 title=myToDoUpdate
	```
	
	**Server Response:**
	Todo Update (0.5ms)  UPDATE "todos" SET "title" = ?, "updated_at" = ? WHERE "todos"."id" = ?  [["title", "myToDoUpdate"], ["updated_at", "2023-01-26 18:18:16.066869"], ["id", 1]]

	```
	http GET :3000/todos/1
	```
	>{  
	    "created_at": "2023-01-26T17:54:02.898Z",  
	    "created_by": "danae",  
	    "id": 1,  
	    "title": "myToDoUpdate",  
	    "updated_at": "2023-01-26T18:18:16.066Z"  
	}

1. Delete a todo and its items
	```
	http DELETE :3000/todos/1
	```
	
	**Server Response:** Parameters: {"id"=>"1"}  
	  Todo Load (0.3ms)  SELECT "todos".* FROM "todos" WHERE "todos"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
	  ↳ app/controllers/todos_controller.rb:41:in 'set_todo'
	  TRANSACTION (0.1ms)  begin transaction
	  ↳ app/controllers/todos_controller.rb:29:in 'destroy'
	  Item Load (0.2ms)  SELECT "items".* FROM "items" WHERE "items"."todo_id" = ?  [["todo_id", 1]]
	  ↳ app/controllers/todos_controller.rb:29:in 'destroy'
	  Item Destroy (0.5ms)  DELETE FROM "items" WHERE "items"."id" = ?  [["id", 1]]
	  ↳ app/controllers/todos_controller.rb:29:in 'destroy'
	  Todo Destroy (0.3ms)  DELETE FROM "todos" WHERE "todos"."id" = ?  [["id", 1]]

1. Logout
	```
	http GET :3000/auth/logout
	```
	>{  
	    "message": "Logged out successfully."  
	} 

	**Server Response:** Started GET "/auth/logout" for 127.0.0.1 at 2023-01-26 20:25:45 +0200
	Processing by AuthenticationController#destroy as */*
	Completed 200 OK in 5ms (Views: 0.3ms | Allocations: 420)

## Deployment

