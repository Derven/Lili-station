client/Move() return 0

mob
	step_size = 8

	var
		fractionalX = 0 // Fractional pixel steps
		fractionalY = 0

	proc
		Translate(vectorX=0, vectorY=0, faceDir)

			// Factor in previous fractional movements
			vectorX += fractionalX
			vectorY += fractionalY

			fractionalX = vectorX
			vectorX = round(vectorX)
			fractionalX -= vectorX

			fractionalY = vectorY
			vectorY = round(vectorY)
			fractionalY -= vectorY


			// Move in components
			if(vectorX > 0)
				step(src, EAST, vectorX)
			else if(vectorX < 0)
				step(src, WEST, -vectorX)

			if(vectorY > 0)
				step(src, NORTH, vectorY)
			else if(vectorY < 0)
				step(src, SOUTH, -vectorY)

			// Face in direction specified
			if(faceDir) dir = faceDir

	Player
		step_size = 48

		var
			walkingSpeed = 4
			runningSpeed = 8
			crouchingSpeed = 1
			stamina = 999999

			lastMoveX = 0
			lastMoveY = 0
			slideMultiplier = 0

			lockedDir = 0
			lockedDirTimer = 0

		New()
			..()
			spawn()
				Movement()

		proc
			Movement()
				spawn()
					while(src)
						var
							moveY = 0
							moveX = 0

						if(client.IsKeyActive("w") || client.IsKeyActive("NORTH")) { moveY++ }
						if(client.IsKeyActive("d") || client.IsKeyActive("EAST")) { moveX++ }
						if(client.IsKeyActive("s") || client.IsKeyActive("SOUTH")) { moveY-- }
						if(client.IsKeyActive("a") || client.IsKeyActive("WEST")) { moveX-- }

						// Stand in place
						if(client.IsKeyDown("ctrl") && (moveX || moveY))
							lockedDir = VectorToDir(moveX, moveY)
							lockedDirTimer = 3
							moveX = 0
							moveY = 0
						// Actually move
						else
							// Reduce speed on diagonals (which are actually the cardinals in iso!)
							if(moveX && moveY)
								moveX *= UNIT_DIAGONAL_COMPONENT
								moveY *= UNIT_DIAGONAL_COMPONENT

							// Check if running or walking
							var/speed = walkingSpeed
							if(client.IsKeyDown("alt"))
								speed = crouchingSpeed
							else if(client.IsKeyDown("shift") && stamina>0)
								speed = runningSpeed
								stamina -= 3

							moveX *= speed
							moveY *= speed

						// Average in last velocity
						if(abs(lastMoveX) > 1 || abs(lastMoveY) > 1)
							moveX = (moveX + slideMultiplier*lastMoveX) / (slideMultiplier + 1)
							moveY = (moveY + slideMultiplier*lastMoveY) / (slideMultiplier + 1)

							if(abs(moveX) < FLOAT_TOLERANCE) moveX = 0
							if(abs(moveY) < FLOAT_TOLERANCE) moveY = 0

						if(lockedDir && lockedDirTimer > 0)
							dir = lockedDir

						// Actually move
						if(moveX || moveY)
							if(!lockedDir) dir = VectorToDir(moveX, moveY)
							Translate(moveX, moveY, dir)
						// Regain stamina if standing still
						else if(stamina < 100)
							stamina = min(100, stamina+1)


						lastMoveX = moveX
						lastMoveY = moveY

						if(lockedDirTimer > 0)
							lockedDirTimer--
						else
							lockedDir = 0

						sleep(world.tick_lag)

