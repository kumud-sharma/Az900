{
	 "if": {
	    "anyOf": [
		 {
			"not": {
			  "anyOf": [
                    {
				    "field": "type",
				    "like": "Microsoft.Compute/disks/*"
				    },
                    {
				    "field": "type",
				    "like": "Microsoft.Compute/virtualMachines/*"
				    },
                    {
				    "field": "type",
				    "like": "Microsoft.Network/networkInterfaces/*"
				    },
                    {
				    "field": "type",
				    "like": "Microsoft.Network/networkSecurityGroups/*"
				    },
                    {
				    "field": "type",
				    "like": "Microsoft.Network/publicIPAddresses/*"
				    },
                    {
				    "field": "type",
				    "like": "Microsoft.Network/virtualNetworks/*"
				    },
                    {
				    "field": "type",
				    "like": "Microsoft.Storage/storageAccounts/*"
				    },
                    {
				    "field": "type",
				    "in": ["Microsoft.Compute/disks", "Microsoft.Compute/virtualMachines", "Microsoft.Network/networkInterfaces", "Microsoft.Network/networkSecurityGroups", "Microsoft.Network/publicIPAddresses", "Microsoft.Network/virtualNetworks", "Microsoft.Storage/storageAccounts"]
				    }
                ]
			}
		 },
          {
		  "allof": [
			{
			  "field": "type",
			  "equals": "Microsoft.Compute/disks"
			},
			{
			  "not": {
				"field": "Microsoft.Compute/disks/Sku.Tier",
				"in": ["Standard"]
				}
			  }
			]
		  },
          {
		  "allOf": [
			{
			  "field": "type",
			  "equals": "Microsoft.Compute/virtualMachines"
			},
			{
			  "not": {
				"allOf": [
				  {
                    "field": "Microsoft.Compute/virtualMachines/imageOffer",
					"in": ["WindowsServer"]
				  },
				  {
					"field": "Microsoft.Compute/virtualMachines/imagePublisher",
					"in": ["MicrosoftWindowsServer"]
				  },
				  {
					"field": "Microsoft.Compute/virtualMachines/imageSku",
					 "in": ["2019-Datacenter"]
				  },
				  {
					"field": "Microsoft.Compute/virtualMachines/sku.name",
					"in": ["Standard_D2_v3"]
				  }
				]
			  }
			}
		   ]
		},
            {
			"allOf": [
			  {
				"source": "action",
				"equals": "Microsoft.Storage/storageAccounts/write"
			  },
			  {
				"field": "type",
				"equals": "Microsoft.Storage/storageAccounts"
			  },
			  {
				"not": 
				  {
					"field": "Microsoft.Storage/storageAccounts/sku.name",
					"in": ["StandardLRS"]
				  }
			   }
			]
		  },

	  ]
	},
	"then": {
	  "effect": "deny"
	}
}
