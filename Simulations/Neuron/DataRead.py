from intern import array
import matplotlib.pyplot as plt

# to make a neuroglancer link
from IPython.display import display, HTML

# Define dataset location and example bounds!
bossdb_url = "bossdb://nguyen_thomas2022/cb2/em"


# Provide the dataset URI (collection/experiment/channel) to access the data. By default accesses the base resolution.
bossdb_dataset = array(bossdb_url)


# bossdb_dataset can be treated like a numpy array to get information on the size and type of the whole dataset. It also contains dataset-specific attributes such as resolution.
print(bossdb_dataset.shape)
print(bossdb_dataset.resolution)


# Save a cutout to a numpy array in ZYX order:
my_cutout = bossdb_dataset[600:606, 111362:112386, 123826:124850]

# the cutout is just a large numpy array
my_cutout[1]


# you can visualize it using matplotlib or your favorite visualization package
plt.imshow(my_cutout[5])


# get a link to view the dataset on Neuroglancer
bossdb_dataset.visualize
