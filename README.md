# Tdms-Trainning-genai
# Teste

# Arquitetura do projeto

Public GitHub link to access the project structure: https://github.com/Ritain-io/tdms-trainning-genai

Beginning with the migration, we can find a file that creates the customers table. The link to access the code for this file is: https://github.com/Ritain-io/tdms-trainning-genai/blob/main/db/migrate/20180924174218_create_customers.rb

After creating the customers table, the model is called to communicate with it. Therefore, the customers.rb file is used, and here is the link to access it: https://github.com/Ritain-io/tdms-trainning-genai/blob/main/app/controllers/api/v1/customers_controller.rb

Following this communication, the customers controller is called. The code can be found at this link: https://github.com/Ritain-io/tdms-trainning-genai/blob/main/app/controllers/api/v1/customers_controller.rb

The controller, in turn, calls its services, and the file containing the code is located at: https://github.com/Ritain-io/tdms-trainning-genai/blob/main/app/services/api/customers.rb

Based on the output provided in the controller, it then passes through the customer serializer. The serializer's code can be found at this link: https://github.com/Ritain-io/tdms-trainning-genai/blob/main/app/serializers/customer_serializer.rb

Finally, we have the customer policy, which validates whether there are permissions to access the controller. The code is available at the following link: https://github.com/Ritain-io/tdms-trainning-genai/blob/main/app/policies/customer_policy.rb