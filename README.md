## JP1/AJS Job execution result log visualization.
### Features
* [Upload] Update ajs result data to elasticsearch via output file of `ajsshow -g a AJSROOTX/hogehoge` command.
* [Visualize] Timeline style visualization for specific date result of jobs. Data from elasticseach by uploaded.
### Scripts
* mapping_data.sh: Recreate ajs template for elasticsearch.
* post_data.sh: Post sample data to elasticsearch.
