# Instabug Backend Challenge 2022 

## To run the code  

``` 
docker-compose up --build
```

## Assumptions and notes: 

- The application is containerized using **docker**. 
- **Redis**:
    - To get number of chats from a certain application, increment it, and assigned it to a newly created chat 
    - To get number of messages from a certain chat, increment it, and assigned it to a newly created message 
    
  **using ` incr ` command from redis.**
  
