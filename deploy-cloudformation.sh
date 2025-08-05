aws cloudformation update-stack \
  --stack-name minecraft-madness \
  --template-body file://cloudformation/minecraft-madness.yaml \
  --parameters ParameterKey=InstanceName,ParameterValue=minecraft-madness-1