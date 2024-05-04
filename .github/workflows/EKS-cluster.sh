AWSTemplateFormatVersion: '2010-09-09'
Description: CloudFormation template to create an AWS EKS cluster

Parameters:
  ClusterName:
    Type: String
    Description: EKS cluster
  VpcId:
    Type: AWS::EC2::VPC::Id
    Description: ID of the existing Amazon VPC for the cluster
  SubnetIds:
    Type: List<AWS::EC2::Subnet::Id>
    Description: List of subnet IDs in the existing VPC
  KeyName:
    Type: AWS::EC2::KeyPair::KeyName
    Description: EC2 key pair to associate with the worker nodes
  NodeGroupName:
    Type: String
    Description: Name of the EKS node group

Resources:
  EKSCluster:
    Type: AWS::EKS::Cluster
    Properties:
      Name: !Ref ClusterName
      ResourcesVpcConfig:
        VpcId: !Ref VpcId
        SubnetIds: !Ref SubnetIds

  EKSNodeGroup:
    Type: AWS::EKS::Nodegroup
    Properties:
      ClusterName: !Ref ClusterName
      NodegroupName: !Ref NodeGroupName
      Subnets: !Ref SubnetIds
      ScalingConfig:
        DesiredSize: 2
        MaxSize: 3
        MinSize: 1
      InstanceTypes:
        - t3.medium
      RemoteAccess:
        Ec2SshKey: !Ref KeyName

Outputs:
  EKSClusterName:
    Description: Name of the created EKS cluster
    Value: !Ref ClusterName
