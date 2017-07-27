function docker_clean -d 'remoove unused docker containers, images, volumes'
  # Delete all containers
  command docker rm (docker ps -a -q)

  # Delete all images
  command docker rmi (docker images -q)

  # Delete all volumes
  command docker volume rm (docker volume ls -qf dangling=true)
end
