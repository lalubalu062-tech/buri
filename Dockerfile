# Base image wahi use karenge jo maine batayi thi
FROM kristiankramer/ebesucher-docker:latest

# Yahan apna eBesucher username daal kar pack kar do
ENV SURFBAR=Dingo_Bingo

# Base image ka apna setup commands isme apne aap chal jayega, 
# isliye alag se CMD likhne ki zaroorat nahi hai.
