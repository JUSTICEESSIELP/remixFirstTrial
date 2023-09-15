// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract GreenaceChain {
  

    struct OrganizationContact{
        string email;
        string phone;
    }


      struct Organization {
        address creator;
        string name;
        string about;
        string location;
       
    }

    struct Project{
        string name;
        uint goalAmount;
        uint currentAmount;
        uint createdTimestamp;

    }
    Organization[] public organizations;
    Project[] public projects;

    mapping(address => []Project) organizationsToProject;

    function createOrganization(string memory _name, string memory _about, string memory location) public {
        Organization memory newOrganization = Organization({
            creator: msg.sender,
            name: _name,
            about: _about,
     
        });
        organizations.push(newOrganization);
    }

    function createProject(string memory _name, uint _goalAmount, uint _currentAmount) public {
         Project memory newProject = Project({
             name:_name,
             goalAmount:_goalAmount;
             currentAmount:_currentAmount;
             createdTimestamp:block.timespan;
         })

    }



}