# Parameters
Nannuli <- 10  # Number of annuli
r <- 1/2       # Initial radius
dr2 <- r / (Nannuli - 1) / 2  # Half thickness of the outermost annulus

# Loop-based computation
loop_vrat <- numeric(Nannuli)
loop_frat <- numeric(Nannuli)

# Initial conditions for loop
loop_vrat[1] <- 0
loop_frat[1] <- 2 * r

# Loop to compute values for the annuli
for (i in 1:(Nannuli - 1)) {
  # Calculate interior half of annulus volume
  loop_vrat[i] <- loop_vrat[i] + pi * (r - dr2 / 2) * 2 * dr2
  r <- r - dr2
  
  # Calculate the area ratio for the current annulus
  loop_frat[i] <- 2 * pi * r / (2 * dr2)
  
  # Update r for outer half of annulus
  r <- r - dr2
  # Calculate outer half of annulus volume
  loop_vrat[i + 1] <- pi * (r + dr2 / 2) * 2 * dr2
}

# Print and compare the results
print("Loop-based Volume Ratios:")
print(loop_vrat)

print("Loop-based Area Ratios:")
print(loop_frat)

# Reset r for closed-form calculation
r <- 1/2  
dr<-(r/(Nannuli-1))/2

# Initial conditions for loop
#loop_vrat[1] <- 0
#loop_frat[1] <- 2 * r


# Closed-form computation
closed_vrat <- closed_vrat1 <-numeric(Nannuli)
closed_frat <- numeric(Nannuli)

# Loop through each annulus for closed-form calculation
for (i in 0:(Nannuli - 2)) { 
  # Compute the area ratio (closed-form)
  closed_frat[i + 1] <- 2 * pi *  (r-(((2*i)+1)*dr)) / (2*dr)
  #closed_vrat[i + 1] <-   (pi *  ((r-(((2*i)+2)*dr)) + (dr/2)) *(2*dr)) + (pi *  ((r-(((2*i)+2)*dr)) - (dr/2)) *(2*dr))
  closed_vrat1[i + 1] <-   4*pi*dr *(r-(((2*i)+2)*dr)) 
}

# Print and compare the closed-form results
print("Closed-form Volume Ratios:")
print(closed_vrat)

print("Closed-form Area Ratios:")
print(closed_frat)

# Verify if they match exactly
print("Do the loop-based and closed-form volume ratios match?")
print(all.equal(loop_vrat, closed_vrat))

print("Do the loop-based and closed-form area ratios match?")
print(all.equal(loop_frat, closed_frat))




# Parameters
Nannuli <- 10  # Number of annuli
r <- 1/2       # Initial radius
dr <- r / (Nannuli - 1)  # Thickness of each annulus

# Initialize closed-form values
closed_frat <- numeric(Nannuli)
closed_vrat <- numeric(Nannuli)

# Loop through each annulus for closed-form calculation
for (i in 0:(Nannuli - 1)) {  
  # Compute the area ratio for each annulus (closed-form) - implicitly using r_current
  closed_frat[i + 1] <- 2 * pi * (r - i * dr - ((2 * i - 1) * dr)) / (2 * dr)
  
  # Compute the volume for each annulus (closed-form) - implicitly using r_current
  closed_vrat[i + 1] <- 4 * pi * dr * (r - i * dr - ((2 * i) * dr))
}
