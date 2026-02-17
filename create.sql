		create table ContractOption
		(
			id  serial not null primary key,
			contract_number Varchar(20) not null,
            option_code Varchar(20) not null,
            FOREIGN KEY (option_code) REFERENCES AdditionalOption (option_code),
            quantitly int not null,
            actual_unit_price decimal(10, 2) not null,
            total_price decimal(10, 2) not null
		);
        create table InventorySpecification
		(
			spec_name serial not null primary key,
            FOREIGN KEY (inventory_id) REFERENCES Inventory (inventory_id),
            spec_value Varchar(20) not null,
            unit Varchar(20) not null
		);
        
        create table AdditionalOption
		(
			option_code serial not null primary key,
			option_name Varchar(100) not null,
            description_id Varchar(20) not null,
            unit_price decimal(10, 2) not null,
            unit_type Varchar(20) not null,
            is_available boolean default true not null
		);
        
        create table Inventory
		(
			inventory_id serial not null primary key,
			item_name Varchar(100) not null,
            brand_model Varchar(100) not null,
            item_type Varchar(20) not null,
            total_quantitly int not null,
            available_quantitly int not null,
            purchase_price decimal(10, 2) not null,
            rental_price_per_hour decimal(10, 2) not null,
            condition_status Varchar(20) not null,
            last_maintenance_date date not null,
            next_maintenance_date date not null
		);
        
        create table InventoryRental
		(
			rental_id serial not null primary key,
            FOREIGN KEY (inventory_id) REFERENCES Inventory (inventory_id),
            contract_number Varchar(20) not null,
            quantitly int not null,
            rental_hours int not null,
            unit_price decimal(10, 2) not null,
            total_price decimal(10, 2) not null,
            rental_status Varchar(20) not null,
            planned_issue_time timestamp not null,
            actual_issue_time timestamp not null,
            planned_return_time timestamp not null,
            actual_return_time timestamp not null,
            notes text not null,
            damage_description text not null,
            penalty_amount decimal(10, 2) not null
		);
        
        create table Employee
		(
			login serial not null primary key,
            password_hash Varchar(255) not null,
            full_name Varchar(150) not null,
			email Varchar(100) not null,
            phone Varchar(20) not null,
            hire_date Varchar(20) null,
            position Varchar(20) not null,
            is_active boolean not null,
            created_at timestamp not null,
            updated_at timestamp not null
		);