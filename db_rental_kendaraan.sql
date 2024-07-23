-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 23 Jul 2024 pada 20.10
-- Versi server: 10.4.27-MariaDB
-- Versi PHP: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_rental_kendaraan`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `berdasarkanjenis` (IN `jenis_cari` VARCHAR(20))   BEGIN
    SELECT *
    FROM kendaraan
    WHERE jenis COLLATE utf8mb4_general_ci = jenis_cari COLLATE utf8mb4_general_ci; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CalculateTotalBiaya` ()   BEGIN
    SELECT 
        YEAR (tanggal_peminjaman) AS tahun,
        SUM(total_biaya) AS total_sewa_keseluruhan
    FROM 
        transaksi_peminjaman 
WHERE year(tanggal_peminjaman) = 2024
    GROUP BY 
          YEAR (tanggal_peminjaman);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertcustomer` (`id_customer` CHAR(5), `nama_customer` VARCHAR(50), `email` VARCHAR(30), `no_hp` VARCHAR(12))   BEGIN
    INSERT INTO customer
    VALUES (id_customer, nama_customer, email, no_hp);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `selectkendaraan` ()   BEGIN
    SELECT no_plat, jenis, merk, warna FROM kendaraan;
END$$

--
-- Fungsi
--
CREATE DEFINER=`root`@`localhost` FUNCTION `CustomerMemilihMobil` (`noplat` VARCHAR(20), `merk` VARCHAR(50)) RETURNS INT(11) DETERMINISTIC BEGIN 
    DECLARE jumlah INT ;
    SELECT COUNT(id_customer) INTO jumlah
    FROM transaksi_peminjaman
WHERE no_plat = noplat COLLATE utf8mb4_general_ci; 
    RETURN jumlah; 
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `pendapatanTiapSupir` (`tarif` INT, `idSupir` CHAR(5)) RETURNS DECIMAL(10,2) DETERMINISTIC BEGIN 
    DECLARE PendapatanSupir DECIMAL(10,2);
    SELECT SUM(tarif) INTO PendapatanSupir
    FROM transaksi_peminjaman tp
    WHERE tp.id_supir = idSupir COLLATE utf8mb4_general_ci; 
    RETURN PendapatanSupir; 
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `tarifKendaraanStatus` (`tarif` INT) RETURNS VARCHAR(10) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN 
DECLARE statusHarga varchar(10);
IF tarif<425000 THEN SET statusHarga = 'Murah'; elseif tarif>425000 then 
SET statusHarga = 'Mahal';
END IF;
RETURN statusHarga; 
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `TotalCustomerYangMenyewa2024` (`idCustomer` CHAR(5)) RETURNS INT(11) DETERMINISTIC BEGIN 
    DECLARE TotalCustomerYangMenyewa2024 INT ;
    SELECT COUNT(id_customer) INTO TotalCustomerYangMenyewa2024
    FROM transaksi_peminjaman
WHERE YEAR (tanggal_peminjaman) = 2024 
    AND id_customer = idCustomer COLLATE utf8mb4_general_ci; 
    RETURN TotalCustomerYangMenyewa2024; 
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `admin`
--

CREATE TABLE `admin` (
  `id_admin` char(5) NOT NULL,
  `username` varchar(15) NOT NULL,
  `password` varchar(20) NOT NULL,
  `nama_admin` varchar(50) NOT NULL,
  `no_hp` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `admin`
--

INSERT INTO `admin` (`id_admin`, `username`, `password`, `nama_admin`, `no_hp`) VALUES
('A0001', 'dhimas', 'dhimas123', 'Dhimas Paijo', '081423982751'),
('A0002', 'brilyan', 'brilyan76', 'Brilyan Santoso', '084237891701'),
('A0003', 'roland', 'roland89', 'Roland Mahathir', '089752618917'),
('A0004', 'gilangGs', 'gilang45', 'Gilang Sejati', '087524367281'),
('A0005', 'wisnala11', 'wisnala666', 'Duta Nala', '089763527829');

--
-- Trigger `admin`
--
DELIMITER $$
CREATE TRIGGER `log_admin_changes` AFTER UPDATE ON `admin` FOR EACH ROW BEGIN
    IF NEW.username <> OLD.username OR NEW.password <> OLD.password THEN         INSERT INTO log_admin (id_admin, old_username, new_username, old_password, new_password) 
        VALUES (NEW.id_admin, OLD.username, NEW.username, OLD.password, 
NEW.password);
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `customer`
--

CREATE TABLE `customer` (
  `id_customer` char(5) NOT NULL,
  `nama_customer` varchar(50) NOT NULL,
  `email` varchar(30) NOT NULL,
  `no_hp` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `customer`
--

INSERT INTO `customer` (`id_customer`, `nama_customer`, `email`, `no_hp`) VALUES
('C0001', 'Faeruz Mcqueen', 'faeruzimoetz@gmail.com', '85232696306'),
('C0002', 'Ahmad Lorem', 'loremipsum@gmail.com', '081235472819'),
('C0003', 'Thoriq Hardsoft', 'thoriqdaderdor@gmail.com', '081245763489'),
('C0004', 'Handoko Sitompul', 'handokombledozz@gmail.com', '086556709344'),
('C0005', 'Budi Setiawan', 'budimudo@gmail.com', '087432674433'),
('C0006', 'Andi Cobra', 'andibucin@gmail.com', '085346548732'),
('C0007', 'Lionel Messi', 'lionelissem@gmail.com', '087543568096'),
('C0008', 'Prabowo Subianto', 'prabowosbn@gmail.com', '085347698234'),
('C0009', 'Ganjar Pranowo', 'ganjarpranowo@gmail.com', '087453678543'),
('C0010', 'Anies Baswedan', 'aniskorup@gmail.com', '085643789012'),
('C0011', 'Tsubasa Ozora', 'tsubasa@gmail.com', '089235612378'),
('C0012', 'John Doe', 'john.doe@example.com', '08123456789');

--
-- Trigger `customer`
--
DELIMITER $$
CREATE TRIGGER `log_customer_insert` AFTER INSERT ON `customer` FOR EACH ROW BEGIN
    INSERT INTO log_customer (id_customer, nama_customer, email, no_hp, action, action_time)
    VALUES (NEW.id_customer, NEW.nama_customer, NEW.email, NEW.no_hp, 'INSERT', NOW()); END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `kendaraan`
--

CREATE TABLE `kendaraan` (
  `no_plat` varchar(20) NOT NULL,
  `jenis` varchar(20) NOT NULL,
  `merk` varchar(50) NOT NULL,
  `warna` varchar(20) NOT NULL,
  `tarif_kendaraan` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `kendaraan`
--

INSERT INTO `kendaraan` (`no_plat`, `jenis`, `merk`, `warna`, `tarif_kendaraan`) VALUES
('AB3451HI', 'Matic', 'Toyota Fortuner', 'Putih', 780000),
('AB4351UF', 'Matic', 'Daihatsu Xenia', 'Silver', 325000),
('AB4754SB', 'Matic', 'Toyota Avanza', 'Biru', 325000),
('AB5125KL', 'Manual', 'Daihatsu Terios', 'Hitam', 400000),
('G2453FA', 'Manual', 'Toyota Agya', 'Hitam', 275000),
('G3234JQ', 'Matic', 'Honda Brio', 'Merah', 300000),
('G3245KQ', 'Manual', 'Toyota Hiace', 'Putih', 1200000),
('G3678IF', 'Matic', 'Toyota Alphard', 'Hitam', 1000000),
('G4045KF', 'Manual', 'Mitsubishi Pajero Sport ', 'Hitam', 800000),
('L1906GS', 'Matic', 'Toyota Rush', 'Putih', 400000),
('L2452HJ', 'Manual', 'Daihatsu Sigra', 'Hitam', 290000),
('L2576KT', 'Manual', 'Toyota Ayla', 'Silver', 275000),
('L3365WC', 'Matic', 'Honda Jazz', 'Kuning', 350000),
('L4321FZ', 'Matic', 'Honda CRV', 'Abu-abu', 450000),
('L5939VA', 'Manual', 'Toyota Innova Reborn', 'Putih', 600000);

-- --------------------------------------------------------

--
-- Struktur dari tabel `log_admin`
--

CREATE TABLE `log_admin` (
  `id_admin` char(5) DEFAULT NULL,
  `old_username` varchar(15) DEFAULT NULL,
  `new_username` varchar(15) DEFAULT NULL,
  `old_password` varchar(20) DEFAULT NULL,
  `new_password` varchar(20) DEFAULT NULL,
  `change_time` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `log_admin`
--

INSERT INTO `log_admin` (`id_admin`, `old_username`, `new_username`, `old_password`, `new_password`, `change_time`) VALUES
('A0005', 'wisnala01', 'wisnala11', 'wisnala777', 'wisnala666', '2024-07-24 01:07:13');

-- --------------------------------------------------------

--
-- Struktur dari tabel `log_customer`
--

CREATE TABLE `log_customer` (
  `id_customer` char(5) DEFAULT NULL,
  `nama_customer` varchar(50) DEFAULT NULL,
  `email` varchar(30) DEFAULT NULL,
  `no_hp` varchar(12) DEFAULT NULL,
  `action` varchar(10) DEFAULT NULL,
  `action_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `log_customer`
--

INSERT INTO `log_customer` (`id_customer`, `nama_customer`, `email`, `no_hp`, `action`, `action_time`) VALUES
('C0012', 'John Doe', 'john.doe@example.com', '08123456789', 'INSERT', '2024-07-24 01:04:47');

-- --------------------------------------------------------

--
-- Struktur dari tabel `log_supir`
--

CREATE TABLE `log_supir` (
  `id_supir` char(5) DEFAULT NULL,
  `nama_supir` varchar(50) DEFAULT NULL,
  `no_hp` varchar(12) DEFAULT NULL,
  `action` varchar(10) DEFAULT NULL,
  `action_time` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `log_supir`
--

INSERT INTO `log_supir` (`id_supir`, `nama_supir`, `no_hp`, `action`, `action_time`) VALUES
('S0005', 'Bagong Santosa', '081234567890', 'DELETE', '2024-07-24 01:08:55'),
('S0005', 'Bagong Santosa', '081234567890', 'INSERT', '2024-07-24 01:08:59');

-- --------------------------------------------------------

--
-- Struktur dari tabel `peminjaman`
--

CREATE TABLE `peminjaman` (
  `id_peminjaman` varchar(10) NOT NULL,
  `tanggal_peminjaman` date NOT NULL,
  `tanggal_kembali` date NOT NULL,
  `total_biaya` int(11) NOT NULL,
  `dengan_supir` enum('Y','T') NOT NULL,
  `id_customer` char(5) DEFAULT NULL,
  `no_plat` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `peminjaman`
--

INSERT INTO `peminjaman` (`id_peminjaman`, `tanggal_peminjaman`, `tanggal_kembali`, `total_biaya`, `dengan_supir`, `id_customer`, `no_plat`) VALUES
('P00011', '2023-08-20', '2023-08-22', 900000, 'Y', 'C0004', 'G3234JQ'),
('P00012', '2023-09-12', '2023-09-13', 465000, 'Y', 'C0005', 'AB4754SB'),
('P00013', '2023-09-15', '2023-09-17', 800000, 'T', 'C0009', 'G4045KF'),
('P00014', '2023-09-18', '2023-09-19', 930000, 'Y', 'C0004', 'AB5125KL'),
('P00015', '2023-09-19', '2023-09-20', 325000, 'T', 'C0002', 'L3365WC'),
('P00016', '2023-09-20', '2023-09-22', 580000, 'T', 'C0001', 'L2452HJ'),
('P00017', '2023-12-07', '2023-12-08', 680000, 'Y', 'C0009', 'G2453FA'),
('P00018', '2023-07-02', '2023-07-03', 930000, 'Y', 'C0007', 'AB3451HI'),
('P00019', '2023-11-15', '2023-11-17', 720000, 'Y', 'C0009', 'L2452HJ'),
('P00020', '2023-05-12', '2023-05-13', 500000, 'Y', 'C0002', 'L3365WC'),
('P00021', '2023-08-16', '2023-08-18', 800000, 'T', 'C0004', 'L1906GS'),
('P00022', '2024-01-13', '2024-01-14', 1150000, 'Y', 'C0002', 'G3678IF'),
('P00023', '2024-01-15', '2024-01-17', 2540000, 'Y', 'C0007', 'G3245KQ'),
('P00024', '2024-01-02', '2024-01-03', 275000, 'T', 'C0010', 'L2576KT'),
('P00025', '2024-02-12', '2024-02-13', 430000, 'Y', 'C0004', 'G3234JQ'),
('P00026', '2024-02-03', '2024-02-04', 930000, 'Y', 'C0009', 'G4045KF'),
('P00027', '2024-02-20', '2024-02-22', 580000, 'T', 'C0002', 'L2452HJ'),
('P00028', '2024-03-17', '2024-03-19', 1350000, 'Y', 'C0003', 'L5939VA'),
('P00029', '2024-03-09', '2024-03-10', 325000, 'T', 'C0002', 'AB4754SB'),
('P00030', '2024-04-01', '2024-04-03', 1040000, 'Y', 'C0005', 'L4321FZ'),
('P00031', '2024-05-08', '2024-05-11', 4050000, 'Y', 'C0007', 'G3245KQ'),
('P00032', '2024-05-12', '2024-05-13', 440000, 'Y', 'C0009', 'G3234JQ'),
('P00033', '2024-06-01', '2024-06-02', 290000, 'T', 'C0001', 'L2452HJ'),
('P00034', '2024-03-12', '2024-03-14', 1200000, 'Y', 'C0003', 'L5939VA'),
('P00035', '2024-06-22', '2024-06-23', 400000, 'T', 'C0010', 'AB5125KL'),
('P00036', '2024-05-08', '2024-05-09', 325000, 'Y', 'C0001', 'L5939VA'),
('P00037', '2024-06-19', '2024-06-20', 920000, 'Y', 'C0004', 'AB3451HI'),
('P00038', '2024-02-15', '2024-02-17', 950000, 'Y', 'C0008', 'AB4754SB'),
('P00039', '2024-04-04', '2024-04-05', 400000, 'T', 'C0003', 'L1906GS');

-- --------------------------------------------------------

--
-- Struktur dari tabel `penugasan_supir`
--

CREATE TABLE `penugasan_supir` (
  `penugasan_id` char(10) NOT NULL,
  `tanggal_penugasan` date DEFAULT NULL,
  `durasi` int(11) NOT NULL,
  `id_peminjaman` varchar(10) DEFAULT NULL,
  `id_supir` char(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `penugasan_supir`
--

INSERT INTO `penugasan_supir` (`penugasan_id`, `tanggal_penugasan`, `durasi`, `id_peminjaman`, `id_supir`) VALUES
('PS001', '2023-05-12', 1, 'P00020', 'S0004'),
('PS002', '2023-07-02', 1, 'P00018', 'S0002'),
('PS003', '2023-08-20', 2, 'P00011', 'S0002'),
('PS004', '2023-09-12', 1, 'P00012', 'S0001'),
('PS005', '2023-09-18', 1, 'P00014', 'S0004'),
('PS006', '2023-11-15', 2, 'P00019', 'S0003'),
('PS007', '2023-12-07', 1, 'P00017', 'S0004'),
('PS008', '2024-01-13', 1, 'P00022', 'S0002'),
('PS009', '2024-01-15', 2, 'P00023', 'S0001'),
('PS010', '2024-02-03', 1, 'P00026', 'S0003'),
('PS011', '2024-02-12', 1, 'P00025', 'S0001'),
('PS012', '2024-02-15', 2, 'P00038', 'S0002'),
('PS013', '2024-03-12', 2, 'P00034', 'S0004'),
('PS014', '2024-03-17', 2, 'P00028', 'S0001'),
('PS015', '2024-04-01', 2, 'P00030', 'S0003'),
('PS016', '2024-05-08', 1, 'P00036', 'S0004'),
('PS017', '2024-05-08', 3, 'P00031', 'S0001'),
('PS018', '2024-05-12', 1, 'P00032', 'S0002'),
('PS019', '2024-06-19', 1, 'P00037', 'S0003');

-- --------------------------------------------------------

--
-- Struktur dari tabel `supir`
--

CREATE TABLE `supir` (
  `id_supir` char(5) NOT NULL,
  `nama_supir` varchar(50) NOT NULL,
  `email` varchar(30) NOT NULL,
  `no_hp` varchar(12) NOT NULL,
  `tarif_supir` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `supir`
--

INSERT INTO `supir` (`id_supir`, `nama_supir`, `email`, `no_hp`, `tarif_supir`) VALUES
('S0001', 'Bambang Wahyudi', 'bambangwhyudi@gmail.com', '085674589034', 150000),
('S0002', 'Suroto Broto', 'surotonihboss@gmail.com', '085890456782', 140000),
('S0003', 'Sarjan', 'sarjanvanderoz@gmail.com', '083678965438', 150000),
('S0004', 'Kadir Sukamto', 'kadirkidz@gmail.com', '087124563478', 130000),
('S0005', 'Bagong Santosa', 'bagongS@gmail.com', '081234567890', 165000);

--
-- Trigger `supir`
--
DELIMITER $$
CREATE TRIGGER `log_delete_supir` AFTER DELETE ON `supir` FOR EACH ROW BEGIN
    INSERT INTO log_supir (id_supir, nama_supir, no_hp, action) 
    VALUES (OLD.id_supir, OLD.nama_supir, OLD.no_hp, 'DELETE');
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `log_insert_supir` AFTER INSERT ON `supir` FOR EACH ROW BEGIN
    INSERT INTO log_supir (id_supir, nama_supir, no_hp, action) 
    VALUES (NEW.id_supir, NEW.nama_supir, NEW.no_hp, 'INSERT');
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `transaksi_peminjaman`
--

CREATE TABLE `transaksi_peminjaman` (
  `id_transaksi` varchar(10) NOT NULL,
  `tanggal_peminjaman` date NOT NULL,
  `tanggal_kembali` date NOT NULL,
  `total_biaya` int(11) NOT NULL,
  `id_customer` char(5) DEFAULT NULL,
  `no_plat` varchar(20) DEFAULT NULL,
  `id_supir` char(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `transaksi_peminjaman`
--

INSERT INTO `transaksi_peminjaman` (`id_transaksi`, `tanggal_peminjaman`, `tanggal_kembali`, `total_biaya`, `id_customer`, `no_plat`, `id_supir`) VALUES
('TP001', '2023-05-12', '2023-05-13', 500000, 'C0002', 'L3365WC', 'S0004'),
('TP002', '2023-07-02', '2023-07-03', 930000, 'C0007', 'AB3451HI', 'S0002'),
('TP003', '2023-08-16', '2023-08-18', 800000, 'C0004', 'L1906GS', NULL),
('TP004', '2023-08-20', '2023-08-22', 900000, 'C0004', 'G3234JQ', 'S0002'),
('TP005', '2023-09-12', '2023-09-13', 465000, 'C0005', 'AB4754SB', 'S0001'),
('TP006', '2023-09-15', '2023-09-17', 800000, 'C0009', 'G4045KF', NULL),
('TP007', '2023-09-18', '2023-09-19', 930000, 'C0004', 'AB5125KL', 'S0004'),
('TP008', '2023-09-19', '2023-09-20', 325000, 'C0002', 'L3365WC', NULL),
('TP009', '2023-09-20', '2023-09-22', 580000, 'C0001', 'L2452HJ', NULL),
('TP010', '2023-11-15', '2023-11-17', 720000, 'C0009', 'L2452HJ', 'S0003'),
('TP011', '2023-12-07', '2023-12-08', 680000, 'C0009', 'G2453FA', 'S0004'),
('TP012', '2024-01-02', '2024-01-03', 275000, 'C0010', 'L2576KT', NULL),
('TP013', '2024-01-13', '2024-01-14', 1150000, 'C0002', 'G3678IF', 'S0002'),
('TP014', '2024-01-15', '2024-01-17', 2540000, 'C0007', 'G3245KQ', 'S0001'),
('TP015', '2024-02-03', '2024-02-04', 930000, 'C0009', 'G4045KF', 'S0003'),
('TP016', '2024-02-12', '2024-02-13', 430000, 'C0004', 'G3234JQ', 'S0001'),
('TP017', '2024-02-15', '2024-02-17', 950000, 'C0008', 'AB4754SB', 'S0002'),
('TP018', '2024-02-20', '2024-02-22', 580000, 'C0002', 'L2452HJ', NULL),
('TP019', '2024-03-09', '2024-03-10', 325000, 'C0002', 'AB4754SB', NULL),
('TP020', '2024-03-12', '2024-03-14', 1200000, 'C0003', 'L5939VA', 'S0004'),
('TP021', '2024-03-17', '2024-03-19', 1350000, 'C0003', 'L5939VA', 'S0001'),
('TP022', '2024-04-01', '2024-04-03', 1040000, 'C0005', 'L4321FZ', 'S0003'),
('TP023', '2024-04-04', '2024-04-05', 400000, 'C0003', 'L1906GS', NULL),
('TP024', '2024-05-08', '2024-05-09', 325000, 'C0001', 'L5939VA', 'S0004'),
('TP025', '2024-05-08', '2024-05-11', 4050000, 'C0007', 'G3245KQ', 'S0001'),
('TP026', '2024-05-12', '2024-05-13', 440000, 'C0009', 'G3234JQ', 'S0004'),
('TP027', '2024-06-01', '2024-06-02', 290000, 'C0009', 'L2452HJ', NULL),
('TP028', '2024-06-19', '2024-06-20', 920000, 'C0004', 'AB3451HI', 'S0003'),
('TP029', '2024-06-22', '2024-06-23', 400000, 'C0010', 'AB5125KL', NULL);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `vberapakalisupirbekerja`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `vberapakalisupirbekerja` (
`nama_supir` varchar(50)
,`tanggal_peminjaman` date
,`merk` varchar(50)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `vcustomerdengansupir`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `vcustomerdengansupir` (
`customer_id` int(1)
,`nama_customer` int(1)
,`dengan_supir` int(1)
,`tanggal_peminjaman``tanggal_peminjaman` int(1)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `vcustomermemilihmobil2023`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `vcustomermemilihmobil2023` (
`nama_customer` int(1)
,`merk` int(1)
,`transaksi_tahun``transaksi_tahun` int(1)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `vdatacustomer`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `vdatacustomer` (
`id_customer` int(1)
,`nama_customer` int(1)
,`email` int(1)
,`no_hp``no_hp` int(1)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `vjumlahcustbertransaksi`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `vjumlahcustbertransaksi` (
`nama_customer` int(1)
,`jumlah_transaksi``jumlah_transaksi` int(1)
);

-- --------------------------------------------------------

--
-- Struktur untuk view `vberapakalisupirbekerja`
--
DROP TABLE IF EXISTS `vberapakalisupirbekerja`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vberapakalisupirbekerja`  AS SELECT `s`.`nama_supir` AS `nama_supir`, `t`.`tanggal_peminjaman` AS `tanggal_peminjaman`, `k`.`merk` AS `merk` FROM ((`transaksi_peminjaman` `t` join `supir` `s` on(`t`.`id_supir` = `s`.`id_supir`)) join `kendaraan` `k` on(`t`.`no_plat` = `k`.`no_plat`)) ORDER BY `s`.`nama_supir` ASC  ;

-- --------------------------------------------------------

--
-- Struktur untuk view `vcustomerdengansupir`
--
DROP TABLE IF EXISTS `vcustomerdengansupir`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vcustomerdengansupir`  AS SELECT 1 AS `customer_id`, 1 AS `nama_customer`, 1 AS `dengan_supir`, 1 AS `tanggal_peminjaman``tanggal_peminjaman``tanggal_peminjaman``tanggal_peminjaman`  ;

-- --------------------------------------------------------

--
-- Struktur untuk view `vcustomermemilihmobil2023`
--
DROP TABLE IF EXISTS `vcustomermemilihmobil2023`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vcustomermemilihmobil2023`  AS SELECT 1 AS `nama_customer`, 1 AS `merk`, 1 AS `transaksi_tahun``transaksi_tahun``transaksi_tahun``transaksi_tahun`  ;

-- --------------------------------------------------------

--
-- Struktur untuk view `vdatacustomer`
--
DROP TABLE IF EXISTS `vdatacustomer`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vdatacustomer`  AS SELECT 1 AS `id_customer`, 1 AS `nama_customer`, 1 AS `email`, 1 AS `no_hp``no_hp``no_hp``no_hp`  ;

-- --------------------------------------------------------

--
-- Struktur untuk view `vjumlahcustbertransaksi`
--
DROP TABLE IF EXISTS `vjumlahcustbertransaksi`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vjumlahcustbertransaksi`  AS SELECT 1 AS `nama_customer`, 1 AS `jumlah_transaksi``jumlah_transaksi``jumlah_transaksi``jumlah_transaksi`  ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id_admin`);

--
-- Indeks untuk tabel `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`id_customer`);

--
-- Indeks untuk tabel `kendaraan`
--
ALTER TABLE `kendaraan`
  ADD PRIMARY KEY (`no_plat`);

--
-- Indeks untuk tabel `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD PRIMARY KEY (`id_peminjaman`),
  ADD KEY `id_customer` (`id_customer`),
  ADD KEY `no_plat` (`no_plat`);

--
-- Indeks untuk tabel `penugasan_supir`
--
ALTER TABLE `penugasan_supir`
  ADD PRIMARY KEY (`penugasan_id`),
  ADD KEY `id_peminjaman` (`id_peminjaman`),
  ADD KEY `id_supir` (`id_supir`);

--
-- Indeks untuk tabel `supir`
--
ALTER TABLE `supir`
  ADD PRIMARY KEY (`id_supir`);

--
-- Indeks untuk tabel `transaksi_peminjaman`
--
ALTER TABLE `transaksi_peminjaman`
  ADD PRIMARY KEY (`id_transaksi`),
  ADD KEY `id_customer` (`id_customer`),
  ADD KEY `no_plat` (`no_plat`),
  ADD KEY `id_supir` (`id_supir`);

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD CONSTRAINT `peminjaman_ibfk_1` FOREIGN KEY (`id_customer`) REFERENCES `customer` (`id_customer`),
  ADD CONSTRAINT `peminjaman_ibfk_2` FOREIGN KEY (`no_plat`) REFERENCES `kendaraan` (`no_plat`);

--
-- Ketidakleluasaan untuk tabel `penugasan_supir`
--
ALTER TABLE `penugasan_supir`
  ADD CONSTRAINT `penugasan_supir_ibfk_1` FOREIGN KEY (`id_peminjaman`) REFERENCES `peminjaman` (`id_peminjaman`),
  ADD CONSTRAINT `penugasan_supir_ibfk_2` FOREIGN KEY (`id_supir`) REFERENCES `supir` (`id_supir`);

--
-- Ketidakleluasaan untuk tabel `transaksi_peminjaman`
--
ALTER TABLE `transaksi_peminjaman`
  ADD CONSTRAINT `transaksi_peminjaman_ibfk_1` FOREIGN KEY (`id_customer`) REFERENCES `customer` (`id_customer`),
  ADD CONSTRAINT `transaksi_peminjaman_ibfk_2` FOREIGN KEY (`no_plat`) REFERENCES `kendaraan` (`no_plat`),
  ADD CONSTRAINT `transaksi_peminjaman_ibfk_3` FOREIGN KEY (`id_supir`) REFERENCES `supir` (`id_supir`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
