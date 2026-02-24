create or replace procedure Create_1 ()
language plpgsql
as $$
	begin 
	-- Создание таблицы Clients
	create table if not exists Clients
	(
		oms_number serial not null primary key,
		full_name varchar(150) not null,
		birth_date date not null,
		gender char(1) not null,
		phone varchar(20) not null,
		email varchar(254) not null,
		passport_series varchar(4) not null,
		passport_issue_date date not null,
		passport_issue_by varchar(255) not null,
		passport_division_code varchar(7) not null,
		address text not null,
		registration_date date not null,
		is_verified boolean default true not null
	);
	
	create index if not exists idx_clients_full_name on Clients(full_name);
	create index if not exists idx_clients_phone on Clients(phone);
	create index if not exists idx_clients_email on Clients(email);
	create index if not exists idx_clients_passport_series on Clients(passport_series);
	create index if not exists idx_clients_registration_date on Clients(registration_date);

	create table if not exists Employee
	(
		login serial not null primary key,
		password_hash varchar(255) not null,
		full_name varchar(150) not null,
		email varchar(100) not null,
		phone varchar(20) not null,
		hire_date varchar(20) null,
		position varchar(20) not null,
		is_active boolean not null,
		created_at timestamp not null,
		updated_at timestamp not null
	);
	
	create index if not exists idx_employee_full_name on Employee(full_name);
	create index if not exists idx_employee_email on Employee(email);
	create index if not exists idx_employee_phone on Employee(phone);
	create index if not exists idx_employee_position on Employee(position);
	create index if not exists idx_employee_hire_date on Employee(hire_date);
	create index if not exists idx_employee_is_active on Employee(is_active);

	create table if not exists GameType
	(
		type_code serial not null primary key,
		type_name varchar(100) not null,
		description_id text not null,
		base_price decimal(10, 2) not null,
		duration_minutes int not null,
		max_players int not null,
		min_players int not null,
		is_available boolean default true not null
	);
	
	create index if not exists idx_gametype_name on GameType(type_name);
	create index if not exists idx_gametype_base_price on GameType(base_price);
	create index if not exists idx_gametype_is_available on GameType(is_available);

	create table if not exists GameMap
	(
		map_code serial not null primary key,
		map_name varchar(100) not null,
		description_id text not null,
		difficulty_level int not null,
		rental_price decimal(10, 2) not null,
		area_sqm decimal(8, 2) not null,
		max_players int not null,
		min_players int not null,
		is_available boolean default true not null
	);
	
	create index if not exists idx_gamemap_name on GameMap(map_name);
	create index if not exists idx_gamemap_difficulty on GameMap(difficulty_level);
	create index if not exists idx_gamemap_rental_price on GameMap(rental_price);
	create index if not exists idx_gamemap_is_available on GameMap(is_available);

	create table if not exists Contract
	(
		contract_number serial not null primary key,
		contract_date timestamp not null,
		game_date timestamp not null,
		game_duration int not null,
		game_end_time timestamp not null,
		total_price decimal(10, 2) not null,
		prepayment decimal(10, 2) not null,
		login int not null,
		oms_number int not null,
		type_code int not null,
		payment_status varchar(20) not null,
		notes text not null,
		cancellation_reason text not null,
		foreign key (login) references Employee (login),
		foreign key (oms_number) references Clients (oms_number),
		foreign key (type_code) references GameType (type_code)
	);
	
	create index if not exists idx_contract_contract_date on Contract(contract_date);
	create index if not exists idx_contract_game_date on Contract(game_date);
	create index if not exists idx_contract_login on Contract(login);
	create index if not exists idx_contract_oms_number on Contract(oms_number);
	create index if not exists idx_contract_type_code on Contract(type_code);
	create index if not exists idx_contract_payment_status on Contract(payment_status);
	create index if not exists idx_contract_total_price on Contract(total_price);

	create table if not exists Inventory
	(
		inventory_id serial not null primary key,
		contract_number int not null,
		item_name varchar(100) not null,
		brand_model varchar(100) not null,
		item_type varchar(20) not null,
		total_quantity int not null,
		available_quantity int not null,
		purchase_price decimal(10, 2) not null,
		rental_price_per_hour decimal(10, 2) not null,
		condition_status varchar(20) not null,
		last_maintenance_date date not null,
		next_maintenance_date date not null,
		foreign key (contract_number) references Contract (contract_number)
	);
    
	create index if not exists idx_inventory_contract_number on Inventory(contract_number);
	create index if not exists idx_inventory_item_name on Inventory(item_name);
	create index if not exists idx_inventory_item_type on Inventory(item_type);
	create index if not exists idx_inventory_condition_status on Inventory(condition_status);
	create index if not exists idx_inventory_available_quantity on Inventory(available_quantity);
	create index if not exists idx_inventory_next_maintenance on Inventory(next_maintenance_date);

	create table if not exists AdditionalOption
	(
		option_code serial not null primary key,
		option_name varchar(100) not null,
		contract_number int not null,
		description_id varchar(20) not null,
		unit_price decimal(10, 2) not null,
		unit_type varchar(20) not null,
		is_available boolean default true not null,
		foreign key (contract_number) references Contract (contract_number)
	);
	
	create index if not exists idx_addopt_contract_number on AdditionalOption(contract_number);
	create index if not exists idx_addopt_option_name on AdditionalOption(option_name);
	create index if not exists idx_addopt_unit_price on AdditionalOption(unit_price);
	create index if not exists idx_addopt_is_available on AdditionalOption(is_available);

	create table if not exists Addendum
	(
		addendum_number serial not null primary key,
		contract_number int not null,
		oms_number int not null,
		participant_role varchar(100) not null,
		created_at timestamp not null,
		signed_at timestamp not null,
		foreign key (contract_number) references Contract (contract_number),
		foreign key (oms_number) references Clients (oms_number)
	);
	
	create index if not exists idx_addendum_contract_number on Addendum(contract_number);
	create index if not exists idx_addendum_oms_number on Addendum(oms_number);
	create index if not exists idx_addendum_created_at on Addendum(created_at);
	create index if not exists idx_addendum_signed_at on Addendum(signed_at);

	create table if not exists ContractOption
	(
		id serial not null primary key,
		contract_number int not null,
		option_code int not null,
		quantity int not null,
		actual_unit_price decimal(10, 2) not null,
		total_price decimal(10, 2) not null,
		foreign key (contract_number) references Contract (contract_number),
		foreign key (option_code) references AdditionalOption (option_code)
	);
	
	create index if not exists idx_contractopt_contract_number on ContractOption(contract_number);
	create index if not exists idx_contractopt_option_code on ContractOption(option_code);
	create index if not exists idx_contractopt_total_price on ContractOption(total_price);

	create table if not exists InventorySpecification
	(
		spec_name serial not null primary key,
		inventory_id int not null,
		spec_value varchar(20) not null,
		unit varchar(20) not null,
		foreign key (inventory_id) references Inventory (inventory_id)
	);
	
	create index if not exists idx_invspec_inventory_id on InventorySpecification(inventory_id);
	create index if not exists idx_invspec_spec_value on InventorySpecification(spec_value);

	create table if not exists InventoryRental
	(
		rental_id serial not null primary key,
		inventory_id int not null,
		contract_number int not null,
		quantity int not null,
		rental_hours int not null,
		unit_price decimal(10, 2) not null,
		total_price decimal(10, 2) not null,
		rental_status varchar(20) not null,
		planned_issue_time timestamp not null,
		actual_issue_time timestamp not null,
		planned_return_time timestamp not null,
		actual_return_time timestamp not null,
		notes text not null,
		damage_description text not null,
		penalty_amount decimal(10, 2) not null,
		foreign key (inventory_id) references Inventory (inventory_id),
		foreign key (contract_number) references Contract (contract_number)
	);
	
	create index if not exists idx_invrent_inventory_id on InventoryRental(inventory_id);
	create index if not exists idx_invrent_contract_number on InventoryRental(contract_number);
	create index if not exists idx_invrent_rental_status on InventoryRental(rental_status);
	create index if not exists idx_invrent_planned_issue on InventoryRental(planned_issue_time);
	create index if not exists idx_invrent_planned_return on InventoryRental(planned_return_time);
	create index if not exists idx_invrent_actual_issue on InventoryRental(actual_issue_time);
	create index if not exists idx_invrent_actual_return on InventoryRental(actual_return_time);

	GRANT SELECT, INSERT, UPDATE ON Clients TO rl_manager;
	GRANT USAGE, SELECT ON SEQUENCE clients_oms_number_seq TO rl_manager;
	GRANT SELECT, UPDATE ON Employee TO rl_manager;
	GRANT SELECT, INSERT, UPDATE ON Contract TO rl_manager;
	GRANT USAGE, SELECT ON SEQUENCE contract_contract_number_seq TO rl_manager;
	GRANT SELECT ON GameType TO rl_manager;
	GRANT SELECT ON GameMap TO rl_manager;
	GRANT SELECT, INSERT, UPDATE ON Inventory TO rl_manager;
	GRANT USAGE, SELECT ON SEQUENCE inventory_inventory_id_seq TO rl_manager;
	GRANT SELECT, INSERT, UPDATE ON InventoryRental TO rl_manager;
	GRANT USAGE, SELECT ON SEQUENCE inventoryrental_rental_id_seq TO rl_manager;
	GRANT SELECT, INSERT, UPDATE ON AdditionalOption TO rl_manager;
	GRANT USAGE, SELECT ON SEQUENCE additionaloption_option_code_seq TO rl_manager;
	GRANT SELECT, INSERT, UPDATE ON ContractOption TO rl_manager;
	GRANT USAGE, SELECT ON SEQUENCE contractoption_id_seq TO rl_manager;
	GRANT SELECT, INSERT, UPDATE ON InventorySpecification TO rl_manager;
	GRANT USAGE, SELECT ON SEQUENCE inventoryspecification_spec_name_seq TO rl_manager;
	GRANT SELECT, INSERT, UPDATE ON Addendum TO rl_manager;
	GRANT USAGE, SELECT ON SEQUENCE addendum_addendum_number_seq TO rl_manager;

	GRANT ALL PRIVILEGES ON Clients TO rl_administrator;
	GRANT USAGE, SELECT ON SEQUENCE clients_oms_number_seq TO rl_administrator;
	GRANT ALL PRIVILEGES ON Employee TO rl_administrator;
	GRANT USAGE, SELECT ON SEQUENCE employee_login_seq TO rl_administrator;
	GRANT ALL PRIVILEGES ON Contract TO rl_administrator;
	GRANT USAGE, SELECT ON SEQUENCE contract_contract_number_seq TO rl_administrator;
	GRANT ALL PRIVILEGES ON GameType TO rl_administrator;
	GRANT USAGE, SELECT ON SEQUENCE gametype_type_code_seq TO rl_administrator;
	GRANT ALL PRIVILEGES ON GameMap TO rl_administrator;
	GRANT USAGE, SELECT ON SEQUENCE gamemap_map_code_seq TO rl_administrator;
	GRANT ALL PRIVILEGES ON Inventory TO rl_administrator;
	GRANT USAGE, SELECT ON SEQUENCE inventory_inventory_id_seq TO rl_administrator;
	GRANT ALL PRIVILEGES ON InventoryRental TO rl_administrator;
	GRANT USAGE, SELECT ON SEQUENCE inventoryrental_rental_id_seq TO rl_administrator;
	GRANT ALL PRIVILEGES ON AdditionalOption TO rl_administrator;
	GRANT USAGE, SELECT ON SEQUENCE additionaloption_option_code_seq TO rl_administrator;
	GRANT ALL PRIVILEGES ON ContractOption TO rl_administrator;
	GRANT USAGE, SELECT ON SEQUENCE contractoption_id_seq TO rl_administrator;
	GRANT ALL PRIVILEGES ON InventorySpecification TO rl_administrator;
	GRANT USAGE, SELECT ON SEQUENCE inventoryspecification_spec_name_seq TO rl_administrator;
	GRANT ALL PRIVILEGES ON Addendum TO rl_administrator;
	GRANT USAGE, SELECT ON SEQUENCE addendum_addendum_number_seq TO rl_administrator;

	GRANT SELECT ON Clients TO rl_accountant;
	GRANT SELECT ON Contract TO rl_accountant;
	GRANT SELECT ON InventoryRental TO rl_accountant;
	GRANT SELECT ON AdditionalOption TO rl_accountant;
	GRANT SELECT ON ContractOption TO rl_accountant;
	GRANT SELECT ON GameType TO rl_accountant;
	GRANT SELECT ON GameMap TO rl_accountant;
	GRANT SELECT ON Inventory TO rl_accountant;

	GRANT SELECT, INSERT, UPDATE ON Clients TO rl_operator;
	GRANT USAGE, SELECT ON SEQUENCE clients_oms_number_seq TO rl_operator;
	GRANT SELECT, UPDATE ON Employee TO rl_operator;
	GRANT SELECT, INSERT, UPDATE ON Contract TO rl_operator;
	GRANT USAGE, SELECT ON SEQUENCE contract_contract_number_seq TO rl_operator;
	GRANT SELECT ON GameType TO rl_operator;
	GRANT SELECT ON GameMap TO rl_operator;
	GRANT SELECT, INSERT, UPDATE ON Inventory TO rl_operator;
	GRANT USAGE, SELECT ON SEQUENCE inventory_inventory_id_seq TO rl_operator;
	GRANT SELECT, INSERT, UPDATE ON InventoryRental TO rl_operator;
	GRANT USAGE, SELECT ON SEQUENCE inventoryrental_rental_id_seq TO rl_operator;
	GRANT SELECT, INSERT, UPDATE ON AdditionalOption TO rl_operator;
	GRANT USAGE, SELECT ON SEQUENCE additionaloption_option_code_seq TO rl_operator;
	GRANT SELECT, INSERT, UPDATE ON ContractOption TO rl_operator;
	GRANT USAGE, SELECT ON SEQUENCE contractoption_id_seq TO rl_operator;
	GRANT SELECT, INSERT, UPDATE ON InventorySpecification TO rl_operator;
	GRANT USAGE, SELECT ON SEQUENCE inventoryspecification_spec_name_seq TO rl_operator;
	GRANT SELECT, INSERT, UPDATE ON Addendum TO rl_operator;
	GRANT USAGE, SELECT ON SEQUENCE addendum_addendum_number_seq TO rl_operator;

	GRANT SELECT ON Clients TO rl_analyst;
	GRANT SELECT ON Employee TO rl_analyst;
	GRANT SELECT ON Contract TO rl_analyst;
	GRANT SELECT ON GameType TO rl_analyst;
	GRANT SELECT ON GameMap TO rl_analyst;
	GRANT SELECT ON Inventory TO rl_analyst;
	GRANT SELECT ON InventoryRental TO rl_analyst;
	GRANT SELECT ON AdditionalOption TO rl_analyst;
	GRANT SELECT ON ContractOption TO rl_analyst;
	GRANT SELECT ON InventorySpecification TO rl_analyst;
	GRANT SELECT ON Addendum TO rl_analyst;

end;
$$;
