# Rscript to display data extracted in the experiment

# Read csv file
x = csv.data <- read.csv("new1.csv")

# Check the head of file
head(x)

# Show the data in the first column
x$AvatarA
x$Time

# Width variable
width = 1440.

# StaticA position
statA_pos = width/4.

# StaticB position
statB_pos = 3.*width/4.

# Length of data vectors
length(x$Time)

# Stats position vector
statA = statA_pos*rep(1,length(x$Time))
statB = statB_pos*rep(1,length(x$Time))

# Plot static A object
plot(x = x$Time, y = statA,       # variables
xlim = c(82*0.04,(length(x$Time)-80)*0.04), cex = 0.5, ylim = c(85,2240),       # ranges for axes
col = "black",                                                                   # color
main = "Experiment Results",                                                    # figure title
xlab = "Time (s)", ylab="Postion (pix)")                                        # labeling axes
)

# Plot static B object
points(x = x$Time, y = statB, cex = 0.5, col = "black")

# plot boundaries of search space
rlimit = width * rep(1,length(x$Time))
llimit = 1 * rep(1,length(x$Time))
points(x = x$Time, y = rlimit, cex = 0.3, col = "red")
points(x = x$Time, y = llimit, cex = 0.3, col = "red")

# Plot Time versus Avatar A position
points(x = x$Time, y = x$AvatarA,       # variables
cex = 0.5,                          # size of shapes
col = "cyan")                      # color of shapes

# Plot Time versus Avatar B position
points(x = x$Time, y = x$AvatarB, cex = 0.5, col = "green")


# n-Crosses
x$nCrosses

# In the x$clickA it is necessary to know when the value increase to know in whhich moment both targets cross.
foo = seq(1,length(x$Time))   # sequence from 1 to 100 in steps of 2
foo.diff = NULL
for (i in 1:length(x$Time) ) {
    foo.diff[i] = x$nCrosses[i]-x$nCrosses[i+1]
}

# Or instead, you can compute diff(x,1)
## Default S3 method:
dnCrosses=diff(x$nCrosses, 1)

# Example in one position
dnCrosses!=0
x$Time[1474]

# All the positions in time to plot with AvatarA position
ind_Cros = x$Time[dnCrosses!=0]/0.04                                # 0.04 is the time interval between frames

# Plot crosses when the system gives feedback
points(x = x$Time[ind_Cros],y=x$AvatarA[ind_Cros], pch = 13,cex = 0.8, col = "red")

## Now the clicks for avatarA
x$clickA
x$clickB

# In this case we have ones in the instant that user A clicks so we should need compare that
ind_clA = x$Time[x$clickA!=0]/0.04
ind_clB = x$Time[x$clickB!=0]/0.04

# plot clicks from avatarA
points(x = x$Time[ind_clA], y = x$AvatarA[ind_clA], cex = 0.7, pch = 18, col = "black")

# plot clicks from avatarA
points(x = x$Time[ind_clB], y = x$AvatarB[ind_clB], cex = 0.7, pch = 18, col = "magenta")

# Legend
legend(65,2300, # places a legend at the appropriate place
c("StaticA", "StaticB", "Boundaries", "TargetA", "TargetB","Crosses", "ClickA", "ClickB"), # puts text in the legend
#lty = c(1,1,1,1,1,1,1), # gives the legend appropriate symbols (lines)
#lwd = c(2.5,2.5),        # line width
col = c("black", "black", "red", "cyan", "green", "red", "black", "magenta"), # gives the legend lines the correct color and width
pch = c(1,1,1,1,1,13,18,18)) # different shapes


# Colors for visualitation

# static with greese
# more fine lines
